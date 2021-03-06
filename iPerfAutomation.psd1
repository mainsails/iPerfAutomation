@{

# Script module or binary module file associated with this manifest.
RootModule = 'iPerfAutomation.psm1'

# Version number of this module.
ModuleVersion = '0.1.0'

# ID used to uniquely identify this module
GUID = 'cb9810b6-16c2-4bfa-866c-4fa526431bb5'

# Author of this module
Author = 'Sam Shaw'

# Copyright statement for this module
Copyright = '(c) 2018 Sam Shaw. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Module to assist with iPerf tests, measuring the maximum achievable bandwidth on IP networks'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '4.0'

# Processor architecture (None, X86, Amd64) required by this module
ProcessorArchitecture = 'Amd64'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @('Start-iPerfMonitorTest')

# List of all files packaged with this module
FileList = @('bin\cygwin1.dll','bin\iperf3.exe')

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('iPerf','Network','Bandwidth')

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/mainsails/iPerfAutomation'

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

}