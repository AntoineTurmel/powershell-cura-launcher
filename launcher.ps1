$Host.UI.RawUI.FlushInputBuffer()
[bool]$alwaysLaunchLastVersion = 0
[string]$curaList = ls $Env:Programfiles  | Select-String "Ultimaker"
$curaListVersion = $curaList.Split("Ultimaker Cura").Where({ $_ -ne "" })
$curaLastVersion = ($curaList.Split("Ultimaker Cura").Where({ $_ -ne "" }) | measure-object -Maximum).maximum
#echo "Last Cura version : " $curaLastVersion

if ($alwaysLaunchLastVersion -eq 0) {
    if (($curaLastVersion -gt 5) -or ($curaLastVersion -eq 5))  {
        $curaImg = $Env:Programfiles + "\Ultimaker Cura " + $curaLastVersion + "\share\cura\resources\images\cura-icon-32.png"
    } else {
        $curaImg = $Env:Programfiles + "\Ultimaker Cura " + $curaLastVersion + "\resources\images\cura-icon-32.png"
    }
    # Works with https://github.com/kvaps/zenity-windows
    #$zenintycmd = 'zenity --list   --title="Choose a Cura version"   --column="Check"  --column="Name" --column="Version" --print-column="3" --radiolist ' + $curaList + " --window-icon='" + $curaImg + "'"
    # Works with https://github.com/ncruces/zenity
    $zenintycmd = 'zenity --list  --title="Choose a Cura version"  --column="Version" --window-icon="' + $curaImg + '" ' + $curaListVersion
    $curaVersion = (Invoke-Expression $zenintycmd)
    if (($curaVersion -gt 5) -or ($curaVersion -eq 5))  {
        $curaExe = "Ultimaker-Cura.exe"
    } else {
        $curaExe = "Cura.exe"
    }
} else {
    $curaVersion = $curaLastVersion
}
$curaPath = $Env:Programfiles + "\Ultimaker Cura " + $curaVersion + "\" + $curaExe
if ($curaVersion -gt 0) {
    Invoke-Expression "& '$curaPath'"
}
$Host.UI.RawUI.FlushInputBuffer()