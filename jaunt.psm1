<#
    Module : jaunt.psm1
    Updated: 02/12/2021
    Author : Rudesind <rudesind76@gmail.com>
    Version: 0.1

    Sometimes the best journay is to not know where you're going.
    Jaunt can make that possible. Quickly search websites you choose
    accross the web from the command line.
#>

Function Jaunt {

    <#
    .Synopsis
    .Description
    .Notes
    .Inputs
    .Paramter
    .Example
    #>

    [CmdletBinding()]
    Param (

        [String] $Key,
        [String] $SearchTerm

    )

    # Load Json Config
    #
    $jtConfig = Get-Content '.\jaunt.json' | ConvertFrom-Json
    $c = ConvertPSObjectToHashtable $jtConfig

    # TODO: Jaunt alias: jt
    # TODO: Start in current window vs start in new window
    # Start-Process "https://stackoverflow.com/search?q=$SearchTerm";
    Write-Host 'Jaunt Browser' $c.config.browser
    Write-Host 'Jaunt Engine' $c.engines['g']
}

function ConvertPSObjectToHashtable
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