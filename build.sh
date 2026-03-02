#!/bin/sh
set -e
rm ./code.nes || true
wine ./tools/asm6.exe ./code.asm ./code.nes
