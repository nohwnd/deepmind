function Add-AppveyorTest {
    [CmdletBinding()]
    param
    (
        [Parameter(Position=0, Mandatory=$true)]
        $Name,
                      
        [Parameter(Mandatory=$false)]
        $Framework = $null,
                      
        [Parameter(Mandatory=$false)]
        $FileName = $null,
                      
        [Parameter(Mandatory=$false)]
        $Outcome = $null,
                      
        [Parameter(Mandatory=$false)]
        [long]$Duration = $null,
                      
        [Parameter(Mandatory=$false)]
        $ErrorMessage = $null,
                      
        [Parameter(Mandatory=$false)]
        $ErrorStackTrace = $null,
                      
        [Parameter(Mandatory=$false)]
        $StdOut = $null,
                      
        [Parameter(Mandatory=$false)]
        $StdErr = $null
    )

    throw "Add-AppveyorTest stub was called, but stubs should never be called."
}

