Function Test-ServerAvailability {
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName
    )

    Begin {
        $ErrorActionPreference = 'Stop'
    }
    Process {
        Try {
            ForEach ($Computer in $ComputerName) {
                $Output = @{
                    ComputerName = $Computer
                    Online       = $false
                }
                If (Test-Connection -ComputerName $Computer -Quiet -Count 1) {
                    $Output.Online = $true
                }
                [PSCustomObject]$Output
            }
        }
        Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}