Import-Module $PSScriptRoot\DeepMind.psm1 -Force

Describe "Add-DeepMind" {
    It "Adds <A> and <B> in the cloud and returns <Expected>" -TestCases @(
        @{ A = 1; B = 1; Expected = 2 },
        @{ A = 100; B = 10; Expected = 110 },
        @{ A = -1; B = 1; Expected = 0 }       
    ) {
        param($A, $B, $Expected)
        # -- Arrange

        # -- Act
        $actual = Add-DeepMind -Url "http://dupsug10.0115633a.svc.dockerapp.io" -A $A -B $B

        # -- Assert
        $actual | Should Be $Expected
    }
	
	It "fails because I am testing stuff on appveyor" -TestCases @(
        @{ A = 1; B = 1; Expected = 999 }
    ) {
        param($A, $B, $Expected)
        # -- Arrange

        # -- Act
        $actual = Add-DeepMind -Url "http://dupsug10.0115633a.svc.dockerapp.io" -A $A -B $B

        # -- Assert
        $actual | Should Be $Expected
    }
}