# desktop/build_desktop.ps1 - build the windowed PDP-11 (PDP11Desktop.exe), x64, from PowerShell.
# The engine is found cloned beside this repository (Neon-Arcade-Dispay-Engine next to the
# repository's folder); -Engine <folder/> gives another (the trailing slash matters).
# -Compiler names pbcompilerc.exe where it is not in C:\Program Files\PureBasic\Compilers.
# Linux: build_linux.sh.
param([string]$Engine = "", [string]$Compiler = "C:\Program Files\PureBasic\Compilers\pbcompilerc.exe")
Set-Location $PSScriptRoot
$extra = @()
if ($Engine) { $extra = @('/CONSTANT', "GL_ENGINE_DIR`$=$Engine") }
& $Compiler PDP11Desktop.pb /EXE PDP11Desktop.exe /THREAD /DPIAWARE /OPTIMIZER @extra 2>&1 | Select-Object -Last 6
