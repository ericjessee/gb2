import sys, os
from pathlib import Path
lines = []
with open(sys.argv[1], 'r') as file:
    for line in file:
        if ">>mempath<<" in line:
            lines.append(line.replace(">>mempath<<", f"\"{sys.argv[2]}\""))
        else:
            lines.append(line)
fname = Path(sys.argv[1]).stem
path = f"../../rtl/{fname}_pathed.sv"
if os.path.exists(path):
    os.remove(path)
with open(path, 'x') as outfile:
    for line in lines:
        outfile.write(line)