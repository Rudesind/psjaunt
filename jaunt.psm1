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

    # load INI file
    #
    $iniFile = Get-IniFile ".\jaunt.ini"

    $iniFile

    # TODO: Jaunt alias: jt
    # TODO: Start in current window vs start in new window
    # Start-Process "https://stackoverflow.com/search?q=$SearchTerm";
    Write-Host "Jaunt Passed"

}
Function Get-IniFile {
    <#
    .Synopsis
        This function loads and processes an ini file into a key\value hash table.
    .Description
        This function is part of the INI module. This module is used to read and write data to an INI file with a hash table using a key\value structure.
    .Notes
        Module : INI.psm1
        Updated: 11/13/2018
        Author : Rudesind <rudesind76@gmail.com>
        Version: 1.0
        Disclosure:
        This function is transposed from the following script:
        https://gallery.technet.microsoft.com/scriptcenter/ea40c1ef-c856-434b-b8fb-ebd7a76e8d91
        All functions will be described in detail. All credit goes to the original author: Oliver Lipkau <oliver@lipkau.net>
    .Inputs
        System.String
    .Outputs
        System.Collections.Hashtable
    .Parameter File
        The name of the .ini file including its path.
    .Example
        $iniFile = Get-IniFile example.ini
        $iniFile.section.key
    .Example
        example.ini | $iniFile = Get-IniFile
    #>

    # Allows the script to operate like a compiled cmdlet
    #
    [CmdletBinding()]

    # The inner comments of the Param block will be displayed with: Get-Help ... -Detailed if no Parameter section is defined
    #
    Param(

        # Cannot be $null or ""
        #
        [ValidateNotNullOrEmpty()]

        # Path to the file must exist and have a ".ini" extension
        #
        [ValidateScript({(Test-Path $_) -and ((Get-Item $_).Extension -eq ".ini")})]

        # Parameter is mandatory and allows piped data
        #
        [Parameter(ValueFromPipeline=$True, Mandatory=$True)]

        [string] $File
    )


    # Error Codes
    #
    New-Variable INI_PROCESSING_FAILED -option Constant -value 4000

    # Initialize the function
    #
    try {

        # Friendly error message for the function
        #
        [string] $errorMsg = [string]::Empty

        # Holds the section of the ini file
        #
        [string] $section = [string]::Empty

        # Holds the name of a key for a section
        #
        [string] $key = [string]::Empty

        # Holds the value that relates to a key
        #
        [string] $value = [string]::Empty

        # The hash table
        #
        [object] $ini = $null

        # Holds the comment count found for a particular section
        #
        [float] $CommentCount = 0

    } catch {
        throw "Error initializing function"
        return -1
    }

    # Begin processing the INI file
    #
    try {

        # Create the hash table
        #
        $ini = @{}

        # Create a switch function based on regular expression cases
        #
        switch -regex -file $File {

            # Finds the section from a ini file
            #
            "^\[(.+)\]$" {

                # Pulls the value from the match
                #
                $section = $matches[1]

                # Adds the value to the hash table
                #
                $ini[$section] = @{}

                # Prepares the comments for this section
                #
                $CommentCount = 0
            }

            # Finds any comments in the ini file
            #
            "^(;.*)$" {

                # Checks if there is no section for this call
                #
                if (!($section)) {

                    # No section was found, so add "NoSection" to the hash table
                    #
                    $section = "NoSection"
                    $ini[$section] = @{}
                }

                # Grabs the value of the match
                #
                $value = $matches[1]

                # Increments the amount of comments found for this section
                #
                $CommentCount = $CommentCount + 1

                # Names the comment based on the count
                #
                $key = "Comment" + $CommentCount

                # Adds the value to the current section in the hash table
                #
                $ini[$section][$key] = $value
            }

            # Finds the key\value pair for a section
            #
            "(.+?)\s*=\s*(.*)" {

                if (!($section)) {
                    $section = "NoSection"
                    $ini[$section] = @{}
                }

                # Grabs the values for the key and adds both to hash table
                #
                $key,$value = $matches[1..2]
                $ini[$section][$key] = $value
            }

            # The INI file structure is not recognized
            # 
            default {
                
                $errorMsg = "INI file structure is not recognized: " + $File
                throw $errorMsg

            }
        }

        return $ini

    } catch {
        $errorMsg = "Error processing $File file: " + $Error[0] + $_.Exception.Message
        throw $errorMsg
        return $INI_PROCESSING_FAILED
    }

    return 0

}
