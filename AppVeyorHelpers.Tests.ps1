. $PSScriptRoot\AppVeyorHelpers.ps1

Describe "*-Environment" {
    It "Gets the Set environment" {
        Set-Environment -Environment Release
        Get-Environment | Should Be Release 
    }
}

Describe "Test-ReleaseEnvironment" {
    It "Returns true when the environment is Release" {
        Set-Environment -Environment Release

        Test-ReleaseEnvironment | Should Be $true
    }

    It "Returns false when the environment is not Release" {
        Set-Environment -Environment Development

        Test-ReleaseEnvironment | Should Be $false
    }
}

Describe "Get-Tag" {
    It "Returns value of `$env:APPVEYOR_REPO_TAG_NAME" {
        $expected = "1.0.0-pre"
        $env:APPVEYOR_REPO_TAG_NAME = $expected

        Get-Tag | Should Be $expected
    }
}

Describe "Parse-Tag" {
    It "Given a tag it sets Tag to the value of the tag" {
        $expected = "some tag"
        $tag = Parse-Tag -Tag $expected
        $tag.Tag | Should Be $expected
    }

    It "Given a tag tag that is a valid semantic version it sets Tag to the value of the tag" {
        $expected = "1.1.1-rc"
        $tag = Parse-Tag -Tag $expected
        $tag.Tag | Should Be $expected
    }

    It "Given a tag that is a valid semantic version it sets IsVersionTag to `$true" {
        $tag = Parse-Tag -Tag "1.1.1-rc"
        $tag.IsVersionTag | Should Be $true
    }

    It "Given a tag that is a valid semantic version it sets Version to the non-semantic version" {
        $tag = Parse-Tag -Tag "1.1.1-rc"
        $tag.Version | Should Be "1.1.1"
    }

    It "Given a tag that is a valid semantic version it sets SemanticVersion to value of the tag" {
        $tag = Parse-Tag -Tag "1.1.1-rc"
        $tag.SemanticVersion | Should Be "1.1.1-rc"
    }

    It "Given a tag that is a valid semantic version it sets Suffix to value of the version suffix" {
        $tag = Parse-Tag -Tag "1.1.1-rc"
        $tag.Suffix | Should Be "rc"
    }

    It "Given a tag that is not a valid semantic version it sets IsVersionTag to `$false" {
        $tag = Parse-Tag -Tag "the point of no return"
        $tag.IsVersionTag | Should Be $false
    }

    It "Given a tag that is not a valid semantic version it keeps Version empty" {
        $tag = Parse-Tag -Tag "the point of no return"
        $tag.Version | Should BeNullOrEmpty
    }

    It "Given a tag that is not a valid semantic version it keeps SemanticVersion empty" {
        $tag = Parse-Tag -Tag "the point of no return"
        $tag.SemanticVersion | Should BeNullOrEmpty
    }

    It "Given a tag that is not a valid semantic version it keeps Suffix empty" {
        $tag = Parse-Tag -Tag "the point of no return"
        $tag.Suffix | Should BeNullOrEmpty
    }

    It "Given a tag that has suffix it sets IsPrerelease to `$true" {
        $tag = Parse-Tag -Tag "1.1.1-rc"
        $tag.IsPrerelease | Should Be $true
    }

    It "Given a tag empty tag it sets IsPrerelease to `$true" {
        $tag = Parse-Tag -Tag ""
        $tag.IsPrerelease | Should Be $true
    }

    It "Given a tag that is a version without suffix it sets IsPrerelease to `$false" {
        $tag = Parse-Tag -Tag "1.1.1"
        $tag.IsPrerelease | Should Be $false
    }


}

Describe "Test-ModuleManifestVersionEqualToTagVersion" {
    It "Given a module manifest and tag with the same version it returns `$true" {
        
        [version]$version = "1.1.1"
        $tag = "1.1.1-rc"

        Mock Test-ModuleManifest { [pscustomobject]@{Version = $version } }

        $actual = Test-ModuleManifestVersionEqualToTagVersion -ManifestPath "dummy path" -Tag $tag

        $actual | Should Be $true
    }

    It "Given a module manifest and tag with different versions it returns `$false" {
        
        [version]$version = "2.0.0"
        $tag = "1.1.1-rc"

        Mock Test-ModuleManifest { [pscustomobject]@{Version = $version } }

        $actual = Test-ModuleManifestVersionEqualToTagVersion -ManifestPath "dummy path" -Tag $tag

        $actual | Should Be $false
    }

    It "Calls Test-ModuleManifest with the path that is passed in" {        
        $dummyPath = "dummy path"

        Mock Test-ModuleManifest
        Mock Test-ModuleManifest -ParameterFilter {$Path -eq $dummyPath} 

        $actual = Test-ModuleManifestVersionEqualToTagVersion -ManifestPath "dummy path" -Tag $tag

        Assert-MockCalled Test-ModuleManifest -ParameterFilter {$Path -eq $dummyPath}  -Times 1 
    }
}

Describe "Assert-ModuleManifestVersionEqualToTagVersion" {
    #those tests are incomplete we don't prove that we actually do anything inside of the assert :)
    It "Passes when Test-ModuleManifestVersionEqualToTagVersion returns `$true" {
        Mock Test-ModuleManifestVersionEqualToTagVersion {$true}

        Assert-ModuleManifestVersionEqualToTagVersion -ManifestPath "dummy path" -Tag "dummy tag"
    }

     It "Fails when Test-ModuleManifestVersionEqualToTagVersion returns `$true" {
        Mock Test-ModuleManifestVersionEqualToTagVersion {$false}

        { Assert-ModuleManifestVersionEqualToTagVersion -ManifestPath "dummy path" -Tag "dummy tag" } | Should Throw
    }

}

Describe "Invoke-OnlyDuringRelease" {
    It "Runs provided scriptblock when Release environment is set" {
        Set-Environment -Environment Release
        $expected = "value"
        Invoke-OnlyDuringRelease { $expected } | Should Be $expected
    }

    It "Does not run the provided scriptblock when Release environment is not set" {
        Set-Environment -Environment Development
        Invoke-OnlyDuringRelease { "dummy value" } | Should BeNullOrEmpty
    }
}