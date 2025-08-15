import sys
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from matplotlib.widgets import Button
import tkinter as tk
from tkinter import filedialog

class HexGridGenerator:
    """
    An interactive GUI to create patterns on an 8x48 grid. Supports loading,
    saving, clearing, and click-and-drag painting.
    """
    GRID_ROWS = 8
    GRID_COLS = 48
    TILE_SIZE = 4

    def __init__(self):
        self.grid_data = np.zeros((self.GRID_ROWS, self.GRID_COLS), dtype=int)
        
        # State variables for the paintbrush feature
        self.is_drawing = False
        self.paint_value = 0
        
        # --- Create the Matplotlib Figure and Subplots ---
        self.fig = plt.figure(figsize=(16, 7))
        gs = self.fig.add_gridspec(3, 1, height_ratios=[(self.GRID_ROWS // self.TILE_SIZE), 1.2, 0.5], hspace=0.7)
        
        self.ax_grid = self.fig.add_subplot(gs[0])
        self.ax_hex = self.fig.add_subplot(gs[1])
        
        # MODIFIED: Sub-grid for three buttons: Load, Save, and Clear
        gs_buttons = gs[2].subgridspec(1, 3, wspace=0.15)
        ax_load = self.fig.add_subplot(gs_buttons[0, 0])
        ax_save = self.fig.add_subplot(gs_buttons[0, 1])
        ax_clear = self.fig.add_subplot(gs_buttons[0, 2])

        self.fig.canvas.manager.set_window_title('Interactive Hex Grid Generator')

        # --- Setup the Plots ---
        self.ax_grid.set_title('Click and drag to draw or erase squares')
        self.cmap = ListedColormap(['#FFFFFF', '#000000'])
        self.grid_image = self.ax_grid.imshow(self.grid_data, cmap=self.cmap, interpolation='nearest', vmin=0, vmax=1)
        self._setup_grid_ax()

        self.ax_hex.set_title('Resulting Hexadecimal Values per Tile')
        self.hex_text_objects = self._setup_hex_ax()

        # --- Setup Buttons ---
        self.button_load = Button(ax_load, 'Load from File')
        self.button_load.on_clicked(self._load_from_file)
        self.button_save = Button(ax_save, 'Save to File')
        self.button_save.on_clicked(self._save_to_file)
        self.button_clear = Button(ax_clear, 'Clear Grid')
        self.button_clear.on_clicked(self._clear_grid)

        # --- MODIFIED: Connect new mouse events for drawing ---
        self.fig.canvas.mpl_connect('button_press_event', self._on_press)
        self.fig.canvas.mpl_connect('button_release_event', self._on_release)
        self.fig.canvas.mpl_connect('motion_notify_event', self._on_motion)
        
        self.update_all()

    def _setup_grid_ax(self):
        """Configures the appearance of the main interactive grid."""
        self.ax_grid.set_xticks(np.arange(-.5, self.GRID_COLS, 1), minor=True)
        self.ax_grid.set_yticks(np.arange(-.5, self.GRID_ROWS, 1), minor=True)
        self.ax_grid.grid(which='minor', color='#CCCCCC', linestyle='-', linewidth=0.5)
        self.ax_grid.set_xticks([])
        self.ax_grid.set_yticks([])
        for i in range(1, self.GRID_COLS // self.TILE_SIZE):
            self.ax_grid.axvline(x=i * self.TILE_SIZE - 0.5, color='black', linewidth=1.5)
        for i in range(1, self.GRID_ROWS // self.TILE_SIZE):
            self.ax_grid.axhline(y=i * self.TILE_SIZE - 0.5, color='black', linewidth=1.5)

    def _setup_hex_ax(self):
        """Configures the hex display grid and creates the text objects."""
        self.ax_hex.set_xlim(-0.5, self.GRID_COLS // self.TILE_SIZE - 0.5)
        self.ax_hex.set_ylim(self.GRID_ROWS // self.TILE_SIZE - 0.5, -0.5)
        self.ax_hex.set_xticks(np.arange(self.GRID_COLS // self.TILE_SIZE))
        self.ax_hex.set_yticks(np.arange(self.GRID_ROWS // self.TILE_SIZE))
        self.ax_hex.set_xticklabels([])
        self.ax_hex.set_yticklabels([])
        self.ax_hex.grid(True)
        self.ax_hex.set_aspect('equal')
        text_objects = [[self.ax_hex.text(c, r, '', ha='center', va='center', fontsize=11, fontfamily='monospace')
                         for c in range(self.GRID_COLS // self.TILE_SIZE)] for r in range(self.GRID_ROWS // self.TILE_SIZE)]
        return text_objects

    def _bits_to_int(self, bits):
        return sum(bit * (1 << (3 - i)) for i, bit in enumerate(bits))

    def _int_to_bits(self, n):
        return [int(c) for c in np.binary_repr(n, width=4)]

    def _calculate_hex_values(self):
        """Processes the grid to calculate hex values and format them into three lines."""
        all_hex_bytes_raw = []
        for tile_r in range(self.GRID_ROWS // self.TILE_SIZE):
            for tile_c in range(self.GRID_COLS // self.TILE_SIZE):
                start_r, start_c = tile_r * self.TILE_SIZE, tile_c * self.TILE_SIZE
                tile_data = self.grid_data[start_r:start_r+4, start_c:start_c+4]
                byte1 = (self._bits_to_int(tile_data[0, :]) << 4) | self._bits_to_int(tile_data[1, :])
                byte2 = (self._bits_to_int(tile_data[2, :]) << 4) | self._bits_to_int(tile_data[3, :])
                all_hex_bytes_raw.extend([f"{byte1:02X}", f"{byte2:02X}"])

        formatted_lines = []
        byte_chunks = [all_hex_bytes_raw[i:i + 16] for i in range(0, len(all_hex_bytes_raw), 16)]
        for i, chunk in enumerate(byte_chunks):
            line_str = ",".join([f"${byte}" for byte in chunk])
            if i > 0:
                line_str = "  " + line_str
            formatted_lines.append(line_str)
        
        return formatted_lines

    ### --- New and Modified Event Handlers --- ###

    def _on_press(self, event):
        """Handles the start of a click or drag action."""
        if event.inaxes != self.ax_grid: return
        self.is_drawing = True
        col, row = int(round(event.xdata)), int(round(event.ydata))
        if 0 <= row < self.GRID_ROWS and 0 <= col < self.GRID_COLS:
            # Determine paint color based on the first square clicked
            self.paint_value = 1 - self.grid_data[row, col]
            self.grid_data[row, col] = self.paint_value
            self.update_all()

    def _on_release(self, event):
        """Handles the end of a click or drag action."""
        self.is_drawing = False

    def _on_motion(self, event):
        """Handles mouse movement during a drag action."""
        if not self.is_drawing or event.inaxes != self.ax_grid: return
        col, row = int(round(event.xdata)), int(round(event.ydata))
        if 0 <= row < self.GRID_ROWS and 0 <= col < self.GRID_COLS:
            if self.grid_data[row, col] != self.paint_value:
                self.grid_data[row, col] = self.paint_value
                self.update_all()

    def _clear_grid(self, event=None):
        """Callback for the 'Clear Grid' button."""
        self.grid_data.fill(0)
        self.update_all()

    ### --- File I/O and Update Logic --- ###

    def _parse_and_update_grid(self, text_content):
        """Parses a hex string and updates the grid if valid."""
        sanitized_text = text_content.replace("$", "").replace(",", "").replace(" ", "").replace("\n", "")
        expected_len = self.GRID_ROWS * self.GRID_COLS // 4
        if len(sanitized_text) != expected_len:
            print(f"Error: Invalid file content. Pattern must contain {expected_len // 2} bytes.")
            return

        try:
            byte_values = [int(sanitized_text[i:i+2], 16) for i in range(0, len(sanitized_text), 2)]
        except ValueError:
            print("Error: File contains non-hexadecimal characters.")
            return
            
        new_grid_data = np.zeros_like(self.grid_data)
        byte_index = 0
        for tile_r in range(self.GRID_ROWS // self.TILE_SIZE):
            for tile_c in range(self.GRID_COLS // self.TILE_SIZE):
                start_r, start_c = tile_r * self.TILE_SIZE, tile_c * self.TILE_SIZE
                byte1_val = byte_values[byte_index]
                new_grid_data[start_r, start_c:start_c+4] = self._int_to_bits((byte1_val >> 4) & 0xF)
                new_grid_data[start_r+1, start_c:start_c+4] = self._int_to_bits(byte1_val & 0xF)
                byte2_val = byte_values[byte_index + 1]
                new_grid_data[start_r+2, start_c:start_c+4] = self._int_to_bits((byte2_val >> 4) & 0xF)
                new_grid_data[start_r+3, start_c:start_c+4] = self._int_to_bits(byte2_val & 0xF)
                byte_index += 2
        
        self.grid_data = new_grid_data
        self.update_all()
        print("Successfully loaded pattern from file.")

    def _load_from_file(self, event=None):
        """Opens a file dialog to load a pattern."""
        root = tk.Tk()
        root.withdraw()
        filepath = filedialog.askopenfilename(filetypes=[("Text files", "*.txt"), ("All files", "*.*")])
        if not filepath: return
        try:
            with open(filepath, 'r') as f:
                self._parse_and_update_grid(f.read())
        except Exception as e:
            print(f"Error reading file: {e}")

    def _save_to_file(self, event=None):
        """Opens a file dialog to save the current pattern."""
        content_to_save = "\n".join(self._calculate_hex_values())
        root = tk.Tk()
        root.withdraw()
        filepath = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text files", "*.txt"), ("All files", "*.*")])
        if not filepath: return
        try:
            with open(filepath, 'w') as f:
                f.write(content_to_save)
            print(f"Pattern saved to {filepath}")
        except Exception as e:
            print(f"Error saving file: {e}")

    def update_all(self):
        """Updates all visual components after a change."""
        formatted_lines = self._calculate_hex_values()
        
        # Update grid image
        self.grid_image.set_data(self.grid_data)
        
        # Update hex display plot
        hex_display_data = [] # Rebuild this for the plot
        byte_values = "".join(formatted_lines).replace("$", "").replace(",", "").replace(" ", "").replace("\n", "")
        byte_pairs = [byte_values[i:i+4] for i in range(0, len(byte_values), 4)]
        for i in range(len(self.hex_text_objects)):
            for j in range(len(self.hex_text_objects[0])):
                idx = i * (self.GRID_COLS // self.TILE_SIZE) + j
                hex1, hex2 = byte_pairs[idx][:2], byte_pairs[idx][2:]
                self.hex_text_objects[i][j].set_text(f"0x{hex1}\n0x{hex2}")
        
        # Print raw hex to console
        print("--- Current Grid Hex ---")
        print(byte_values)
        print("-" * len(byte_values))

        self.fig.canvas.draw_idle()

if __name__ == '__main__':
    app = HexGridGenerator()

    if len(sys.argv) > 1:
        filepath = sys.argv[1]
        print(f"Attempting to preload pattern from: {filepath}")
        try:
            with open(filepath, 'r') as f:
                app._parse_and_update_grid(f.read())
        except FileNotFoundError:
            print(f"Error: File not found at '{filepath}'")
        except Exception as e:
            print(f"An error occurred while loading the file: {e}")

    plt.tight_layout(pad=2.0)
    plt.show()