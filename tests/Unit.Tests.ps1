Describe "Basic function unit tests" -Tags Build {
    BeforeAll {
        Unload-SUT
        Import-Module ($global:SUTPath)
    }

    AfterAll {
        Unload-SUT
    }
}

<#
Describe "Test-AdminElevation" {

}



#checks if app is running
#closes app
#times out
#
Describe "Close-Application" {
    context "Execution" {
        mock "Test-AdminElevation" {
            $true
        }
    }
}#>