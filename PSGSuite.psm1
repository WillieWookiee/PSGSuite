#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
    $ModuleRoot = $PSScriptRoot

#Dot source the files
Foreach($import in @($Public + $Private))
    {
    Try
        {
        . $import.fullname
        }
    Catch
        {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

if (-not (Test-Path -Path "$PSScriptRoot\$env:USERNAME-$env:COMPUTERNAME-$env:PSGSuiteDefaultDomain-PSGSuite.xml" -ErrorAction SilentlyContinue))
    {
    Write-Host "Config file not found, starting Configuration Wizard!"
    Start-PSGSuiteConfigWizard
    }

#Initialize the config variable
Try
    {
    #Import the config
    $PSGSuite = $null
    $PSGSuite = Get-PSGSuiteConfig -Source "PSGSuite.xml" -ErrorAction Stop
    }
Catch
    {   
    Write-Warning "Error importing PSGSuite config: $_"
    }
    
Export-ModuleMember -Function $Public.Basename