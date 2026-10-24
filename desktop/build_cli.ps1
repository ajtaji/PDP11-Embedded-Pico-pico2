Set-Location C:\PMFBuild\pdp11\desktop
& 'C:\Program Files\PureBasic\Compilers\pbcompilerc.exe' pdp11_cli.pb /CONSOLE /OPTIMIZER /EXE pdp11_cli.exe 2>&1 | Select-Object -Last 4
