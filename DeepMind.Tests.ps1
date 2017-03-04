function Add-DeepMind ($Url, $A, $B) {
    $body = [pscustomobject]@{
        a = $A;
        b = $B
    } | ConvertTo-Json

    Invoke-WebRequest -Uri "$Url/deepmind/add" -ContentType "application/json" -Method Post -Body $body | 
        select -expand Content
}

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