param(
    [ValidateSet('Debug', 'Release')]
    [string]
    $Configuration = 'Release',

    [string]
    $Version,

    [Switch]
    $Full
)

$ModuleName = 'AzBobbyTables'

$ProjectRoot = "$PSScriptRoot"
$ManifestDirectory = "$ProjectRoot/out/$ModuleName"
$ModuleDirectory = "$ManifestDirectory/$ModuleName"

if (Test-Path $ManifestDirectory) {
    Remove-Item -Path $ManifestDirectory -Recurse
}
New-Item -Path $ManifestDirectory -ItemType Directory
New-Item -Path $ModuleDirectory -ItemType Directory

if ($Full) {
    dotnet build-server shutdown
    dotnet clean
}
dotnet publish $ModuleName -c $Configuration

$ModuleFiles = [System.Collections.Generic.HashSet[string]]::new()

Get-ChildItem -Path "$ProjectRoot/$ModuleName/bin/$Configuration/netstandard2.0/publish" |
Where-Object { $_.Extension -in '.dll', '.pdb', '.xml' } |
ForEach-Object { 
    [void]$ModuleFiles.Add($_.Name); 
    Copy-Item -LiteralPath $_.FullName -Destination $ModuleDirectory 
}

Copy-Item -Path "$ProjectRoot/$ModuleName/Manifest/$ModuleName.psd1" -Destination $ManifestDirectory
if (-not $PSBoundParameters.ContainsKey('Version')) {
    try {
        $Version = gitversion /showvariable LegacySemVerPadded
    }
    catch {
        $Version = [string]::Empty
    }
}
if($Version) {
    $SemVer, $PreReleaseTag = $Version.Split('-')
    Update-ModuleManifest -Path "$ManifestDirectory/$ModuleName.psd1" -ModuleVersion $SemVer -Prerelease $PreReleaseTag
}

Compress-Archive -Path $ManifestDirectory -DestinationPath "$ProjectRoot/$ModuleName.zip" -Force