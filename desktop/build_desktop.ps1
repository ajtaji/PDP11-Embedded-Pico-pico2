# desktop/build_desktop.ps1 - build the windowed PDP-11 (PDP11Desktop.exe), x64, from PowerShell.
# The engine's folder is passed in (the trailing slash matters); -Engine gives another.
param([string]$Engine = "C:/Users/ajtaj/Desktop/Neon-Arcade-Dispay-Engine/")
Set-Location $PSScriptRoot
& 'C:\Program Files\PureBasic\Compilers\pbcompilerc.exe' PDP11Desktop.pb /EXE PDP11Desktop.exe /THREAD /DPIAWARE /OPTIMIZER /CONSTANT "GL_ENGINE_DIR`$=$Engine" 2>&1 | Select-Object -Last 6
