﻿
function Get-Environment () {
    $env:Environment
}

function Set-Environment {
    param 
    (
        [ValidateSet("Development","Release")]
        $Environment = "Development")
    
    $env:Environment = $Environment
}

function Test-ReleaseEnvironment {
    "Release" -eq (Get-Environment)
}

function Get-Tag () {
    $env:APPVEYOR_REPO_TAG_NAME
}


function Parse-Tag ($Tag) {
    #simplified version of the semver regex    
    $isMatch = $Tag -match "^(?<version>\d+\.\d+\.\d+)(\-(?<suffix>[a-z]+))?$"
    if ($isMatch)
    {
        [psCustomObject]@{
            Tag = $Tag
            SemanticVersion = $Tag
            IsVersionTag = $isMatch
            Version = $Matches.version
            Suffix = $Matches.suffix
        }
    }
    else 
    {
        [psCustomObject]@{
            Tag = $Tag
            SemanticVersion = ""
            IsVersionTag = $isMatch
            Version = ""
            Suffix = ""
        }
    }
}

function Test-ModuleManifestVersionEqualToTagVersion ([string]$ManifestPath, [string]$Tag) {
    $manifestVersion = Test-ModuleManifest -Path $ManifestPath | Select -ExpandProperty Version
    $tagVersion = (Parse-Tag -Tag $Tag).Version

    $tagVersion -eq $manifestVersion
}


function Assert-ModuleManifestVersionEqualToTagVersion ([string]$ManifestPath, [string]$Tag) {
    if (-not (Test-ModuleManifestVersionEqualToTagVersion -ManifestPath $ManifestPath -Tag $Tag))
    {
        throw "Expected module manifest version to be the same as the tag version, but the versions differ. Manifest path: '$ManifestPath' Tag: '$Tag'."
    }
}

function Invoke-OnlyDuringRelease ([scriptblock]$ScriptBlock) {
    if ((Get-Environment) -eq "Release") {
        &$ScriptBlock
    }
}