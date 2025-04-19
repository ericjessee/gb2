#this script will take a .gb ROM and convert it to a .coe that can be preloaded into memory inside Xilinx IP
import sys, os

with open(sys.argv[1], 'rb') as rom:
    with open(sys.argv[2], 'x') as mem:
        rom_size=rom.seek(0, os.SEEK_END)
        rom.seek(0)
        for i in range(rom_size-1):
            byte = rom.read(1)
            print(f"{byte.hex()}", file=mem)
        byte = rom.read(1)    
        print(f"{byte.hex()}", file=mem)
