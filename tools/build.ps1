function Build-Addon
{
    Param
    (
        [parameter(mandatory=$true, HelpMessage="Specify Addon Name")]
        [alias("Name")]
        [string]
        $AddonName,
        [parameter(mandatory=$true, HelpMessage="Specify Working Directory")]
        [alias("Path")]
        $AddonPath,
        [parameter(mandatory=$true, HelpMessage="Specify Destination")]
        [alias("Target")]
        $Destination,
        [parameter(HelpMessage="Specify PBOPrefix")]
        [string]
        $PBOPrefix,
        [parameter(HelpMessage="Should certain files be binarized?")]
        [bool]
        $Binarize
    )
    [string]::Format("I've received an instruction to build {0}, path given was {1} and destination is {2}, also prefix is {3}",$AddonName,$AddonPath,$Destination, $PBOPrefix);
    FileBank.exe -property prefix=$PBOPrefix -dst $Destination $AddonPath
    if ($LASTEXITCODE -ne 1) { $FileName = $Destination.FullName + "\" + $AddonName + ".pbo" }
    return [PSCustomObject]@{Type="Arma.PBOAddon"; Path=$FileName}
};

function Sign-Addon
{
    Param
    (
        [parameter(mandatory=$true, HelpMessage="Authority")]
        [alias("Key")]
        [string]
        $Authority,
        [parameter(mandatory=$true, HelpMessage="File to Sign")]
        [alias("Target")]
        $FileToSign
    )
    $AuthorityObject = Get-Item $Authority
    DSSignFile.exe $Authority $FileToSign
    if ($LASTEXITCODE -ne 1) { $BiSignFile = $FileToSign + "." + $AuthorityObject.BaseName + ".bisign" };
    return [PSCustomObject]@{Type="Arma.BISign"; File=$BiSignFile}
};

function Create-BIKeyPair
{
    Param
    (
        [parameter(mandatory=$true, HelpMessage="Name")]
        [alias("Authority")]
        [string]
        $Name,
        [parameter(mandatory=$true, HelpMessage="Destination Folder")]
        [alias("Target")]
        $Destination
    )
    try
    {
        $DestinationPath = Get-Item $Destination -ErrorAction Stop
    }
    catch [System.Management.Automation.ActionPreferenceStopException]
    {
        Write-Host "Destination folder not found, creating.."
        $DestinationPath = New-Item -Type Directory -Path $Destination
    };
    $LastLocation = Get-Location 
    Set-Location $DestinationPath
    DSCreateKey.exe $Name
    Set-Location $LastLocation
    return [PSCustomObject]@{BIKey=[string]::Format("{0}\{1}.bikey", $DestinationPath.FullName, $Name);BIPrivateKey=[string]::Format("{0}\{1}.biprivatekey", $DestinationPath.FullName, $Name)}
}

function Read-AddonMetaInfo
{
    $MetadataJSON = Get-Content .\addon.json
    try
    {
        $MetadataObject = $MetadataJSON | ConvertFrom-Json -ErrorAction Stop
        return $MetadataObject
    }
    catch [System.Management.Automation.ActionPreferenceStopException],[System.Management.Automation.ParameterBindingException]
    {
        Write-Host "Error reading metadata file!"
    };
};

Write-Host "Preparing Enviroment" -ForegroundColor Green
Set-Location $PSScriptRoot
$Project = Read-AddonMetaInfo
$Description = git describe master;

$ProjectName = $Project.metadata."name"
Write-Host "Project: $ProjectName"
$WorkDir = $Project.metadata."working-directory"
try
{
    $WorkDir = Get-Item $WorkDir -ErrorAction Stop
}
catch [System.Management.Automation.ActionPreferenceStopException]
{
    Write-Host "Error setting working directory! Aborting..."
}
Write-Host "Setting Work Directory to $WorkDir" -ForegroundColor Cyan
$ReleaseDir = $Project.metadata."release-dir"
try
{
    $ReleaseDir = Get-Item $WorkDir\$ReleaseDir -ErrorAction Stop
}
catch [System.Management.Automation.ActionPreferenceStopException]
{
    Write-Host "Release directory not found, Creating..."
    $ReleaseDir = New-Item -ItemType Directory -Path $WorkDir -Name "release" -Force
}
Write-Host "Release directory set to $ReleaseDir" -ForegroundColor Cyan
$AddonDir = $Project.metadata."addon-dir"
try
{
    $AddonDir = Get-Item $WorkDir\$AddonDir -ErrorAction Stop
}
catch [System.Management.Automation.ActionPreferenceStopException]
{
    Write-Host "Error setting up addon directory! Aborting..."
}
Write-Host "Source directory set to $AddonDir" -ForegroundColor Cyan

Set-Location $WorkDir

try
{
    $Suppress = Get-Command FileBank.exe -ErrorAction Stop
    $Suppress = Get-Command DSSignFile.exe -ErrorAction Stop
    $Suppress = Get-Command DSCreateKey.exe -ErrorAction Stop
}
catch [System.Management.Automation.ActionPreferenceStopException]
{
    "One or more of required binaries not found!"
}

if ($ReleaseDir.Exists -and (($ReleaseDir.GetDirectories().Count -gt 0) -or ($ReleaseDir.GetFiles().Count -gt 0)))
{
    Write-Host "`n"
    Write-Host "Found files in release directory, deleting..." -ForegroundColor Yellow
    foreach($item in Get-ChildItem $ReleaseDir)
    {
        Write-Host "Removing $item" -ForegroundColor Magenta
        Remove-Item $item.FullName -Force -Recurse
    }
}

$ProjectDir = New-Item -ItemType Directory -Name "@$ProjectName" -Path $ReleaseDir
$AddonsDir = New-Item -ItemType Directory -Name "addons" -Path $ProjectDir
$KeysDir = New-Item -ItemType Directory -Name "keys" -Path $ProjectDir

$TempDir = New-Item -Path $ReleaseDir -Name "temp" -ItemType Directory
$Keys = Create-BIKeyPair -Name ([string]::Format("{0}-{1}",$ProjectName, $Description)) -Destination $TempDir
foreach ($item in Get-ChildItem $AddonDir)
{
    Write-Host ([string]::Format("Building `a `t [[[{0}]]]", $item.BaseName)) -ForegroundColor Green
    $AddonObject = Build-Addon -AddonName $item.BaseName -AddonPath $item.FullName -PBOPrefix ((Get-Content ($item.FullName+"\`$PBOPREFIX$.txt")).Split(" ")[2]) -Destination $AddonsDir
    $BiSign = Sign-Addon -Authority $Keys.BIPrivateKey -FileToSign $AddonObject.Path
    if ($AddonObject.Path -ne "") { Write-Host "Build Successful!`n" -ForegroundColor Green } else { Write-Host "Build Failed :(" -ForegroundColor Green }
}

Copy-Item -Path $Keys.BIKey -Destination $KeysDir
Remove-Item -Path $TempDir -Force -Recurse
foreach ($dirs in $Project."copy-directories")
{
    Copy-Item -Path $WorkDir\$dirs -Destination $ReleaseDir -Recurse -Force
}
