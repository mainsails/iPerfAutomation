Function Test-iPerfServerSession {
    [OutputType([bool])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$ComputerName
    )

    Begin {
        $ErrorActionPreference = 'Stop'
    }
    Process {
        Try {
            $CimParams = @{
                ComputerName = $ComputerName
                ClassName    = 'Win32_Process'
                Filter       = "Name = 'iperf3.exe'"
                Property     = 'CommandLine'
            }
            If (($ServerProc =  Get-CimInstance @CimParams) -and ($ServerProc.CommandLine -match '-s$')) { $true }
            Else { $false }
        }
        Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}