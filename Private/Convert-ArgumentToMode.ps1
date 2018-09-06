Function Convert-ArgumentToMode {
    [OutputType([string])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$iPerfArgs
    )

    Switch ($iPerfArgs) {
        '-s' { 'Server' }
        { $_ -like '*-c*' } { 'Client' }
        default { Throw "Unrecognized input: [$_]" }
    }
}