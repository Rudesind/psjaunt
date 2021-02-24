<#

    Module : jaunt.psm1
    Updated: 02/23/21
    Author : Rudesind <rudesind76@gmail.com>
    Version: alpha

    Summary:
    Command line search engine tool.

#>

# Status codes
#
enum StatusCode {

    FAILED_INITIALIZATION   = 4000
    FAILED_CONFIG_LOAD      = 4001
    SUCCESS                 = 0
    FATAL_ERROR             = -1

}

Function Jaunt {

    # TODO: Finish help
    <#
    .Synopsis
        Command line search engine tool.
    .Description
        Sometimes the best journay is to not know where you're going.
        Jaunt can make that possible. Quickly search with your 
        favorite search engines from the command line.
    .Notes
    .Inputs
    .Paramter
    .Example
    #>

    [CmdletBinding()]
    Param (


        [ValidateNotNullOrEmpty()]
        [Parameter(ValueFromPipeLine=$True, Mandatory=$True)]
        [string] $Key, 

        [ValidateNotNullOrEmpty()]
        [Parameter(ValueFromPipeLine=$True, Mandatory=$True)]
        [String] $Search,

        [ValidateNotNullOrEmpty()]
        [Parameter(DontShow)]
        [System.Management.Automation.SwitchParameter] $Debugging

    )    

    # Debugging
    #
    try {

        if ($Debugging) {

            $DebugPreference = 'Continue'

            Write-Debug 'Jaunt: Debug logging has been enabled'

        }

    } catch {
        return [int][StatusCode]::FATAL_ERROR
    }

    # Initialize Variables
    #
    try {

        # Holds the seetings file as an object
        #
        [PSCustomObeject] $configObj = @()

        # TODO: Cast object correctly
        # Holds the settings file as a hashtable
        #
        $config

    } catch {
        Write-Debug "FATAL ERROR! Could not initialize variables: " + $Error[0]
        return [int][StatusCode]::FATAL_ERROR
    }

    # Load config
    #
    try {

        # TODO: Add comments
        $configObj = Get-Content '.\jaunt.json' | ConvertFrom-Json
        $config = ObjToHash($configObj)
        

    } catch {
        # TODO: Add debug message
        return [int][StatusCode]::FAILED_CONFIG_LOAD
    }

    # TODO: Check for linux vs windfows with $IsLinux or $IsWindows:
    # TODO: nohup - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/start-process?view=powershell-7.1  

    # TODO: Allow for different browser launch
    # TODO: Allow for launch in current session vs new session

    $output = $c.engines[$Key] + $SearchTerm
    Start-Process $output >> $null
}

# TODO: Convert to my style
#
function ObjToHash
{
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )

    process
    {
        if ($null -eq $InputObject) { return $null }

        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string])
        {
            $collection = @(
                foreach ($object in $InputObject) { ConvertPSObjectToHashtable $object }
            )

            Write-Output -NoEnumerate $collection
        }
        elseif ($InputObject -is [psobject])
        {
            $hash = @{}

            foreach ($property in $InputObject.PSObject.Properties)
            {
                $hash[$property.Name] = ConvertPSObjectToHashtable $property.Value
            }

            $hash
        }
        else
        {
            $InputObject
        }
    }
}

# TODO: Add debug function

# TODO: Add "default config" creation