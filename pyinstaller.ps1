Remove-Item -Recurse -Force dist
poetry run task build-script
poetry run task build

$version = (Get-Date).ToString("yy.M.d")
$date = (Get-Date).ToString("yyyyMMdd")
$size = [Math]::Round((Get-ChildItem ./dist/remote_shutdown -Force -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum / 1KB, 0, [MidpointRounding]::AwayFromZero)
.'C:\Program Files (x86)\NSIS\makensis.exe' /DVERSION="$version" /DDATE="$date" /DSIZE="$size" pyinstaller.nsi