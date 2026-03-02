@echo off
IF EXIST code.nes DEL code.nes
tools/asm6.exe code.asm code.nes
