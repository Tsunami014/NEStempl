# NES template
A template for making NES games.

## Structure
- `code.asm` is what is compiled and is the base and contains a lot of stuff you probably won't touch (and variable definitions)
- `game.asm` is only the important code for the game, and contains the mainloop and vblank routines.

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

## How the fudge do I program this thing?
- A list of opcodes for the NES' hardware can be found in [Opcodes.txt](./Opcodes.txt)
- The instructions for the specific ASM6 assembler can be found in [Instructs.txt](./Instructs.txt).
- A lot of helpful guides on how to program stuff can be found on [nesdev.org](https://www.nesdev.org/wiki/Programming_guide)
    - On a subpage of nesdev is a convenient all-in-one reference for the PPU [here](https://www.nesdev.org/wiki/PPU_programmer_reference)
