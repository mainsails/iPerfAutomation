Function ConvertTo-UNCPath {
    [OutputType([string])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]$LocalFilePath,
        [Parameter(Mandatory)]
        [string]$ComputerName
    )

    If ($ComputerName -eq $env:COMPUTERNAME) { "$LocalFilePath" }
    Else {
        $RemoteFilePathDrive = ($LocalFilePath | Split-Path -Qualifier).TrimEnd(':')
        "\\$ComputerName\$RemoteFilePathDrive`$$($LocalFilePath | Split-Path -NoQualifier)"
    }
}