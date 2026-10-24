# desktop/build_cli.ps1 - build the console PDP-11 (pdp11_cli.exe), x64, from PowerShell.
Set-Location $PSScriptRoot
& 'C:\Program Files\PureBasic\Compilers\pbcompilerc.exe' pdp11_cli.pb /CONSOLE /OPTIMIZER /EXE pdp11_cli.exe 2>&1 | Select-Object -Last 4
