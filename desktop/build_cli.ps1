# desktop/build_cli.ps1 - build the console PDP-11 (pdp11_cli.exe), x64, from PowerShell.
# Its clock is the engine's (machine.pbi): the engine is found as build_desktop.ps1 finds it.
# Linux: build_linux.sh.
param([string]$Engine = "", [string]$Compiler = "C:\Program Files\PureBasic\Compilers\pbcompilerc.exe")
Set-Location $PSScriptRoot
$extra = @()
if ($Engine) { $extra = @('/CONSTANT', "GL_ENGINE_DIR`$=$Engine") }
& $Compiler pdp11_cli.pb /CONSOLE /OPTIMIZER /EXE pdp11_cli.exe @extra 2>&1 | Select-Object -Last 4
