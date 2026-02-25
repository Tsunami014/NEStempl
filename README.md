# NES template
A template for making NES games.

## Building the source code
1. Download repo however
1. Run `build.bat` or `./build.sh` (double click in file explorer or run in terminal, I don't care)
2. Ensure it created a file `code.nes`
3. Run said file in an NES emulator (such as the provided `nester.exe`)
    - In the provided nester emulator, select Open ROM and select the `code.nes` to run it. Again, there is the double size option if required
4. Play!

## Editing/Running
**To edit the code**: Edit the `.asm` files in the main folder. `code.asm` is the main file which includes other files in the folder.

**To edit the tileset**: A program such as yychr is required. Use it to edit `tiles.chr`.

**To build**: Run `build.bat` or `./buildLinux` depending on your OS.

**To run**: Run `code.nes` using an NES emulator (after building). `nester.exe` is provided, but for debugging another such as [FCEUX](https://fceux.com/web/download.html) is recommended.

### Opcodes
A very nice list of opcodes for the NES' hardware can be found [here](https://wiki.preterhuman.net/NES_Programming_Guide), and the instructions for the specific ASM6 assembler can be found [here](./Instructs.txt).

