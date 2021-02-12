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

    # TODO: Jaunt alias: jt
    # TODO: Start in current window vs start in new window
    Start-Process "https://stackoverflow.com/search?q=$SearchTerm";

}
Function ParseIni ($file) {


}

