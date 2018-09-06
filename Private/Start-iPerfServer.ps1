Function Start-iPerfServer {
    [OutputType([void])]
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
            If ($runningServers = @($ComputerName).where({ Test-iPerfServerSession -ComputerName $_ })) {
                Write-Verbose -Message "The server(s) [$(($runningServers -join ','))] are already running."
                $ComputerName = @($ComputerName).where({ $_ -notin $runningServers })
            }
            $null = Invoke-iPerf -ComputerName $ComputerName -Arguments '-s'
        }
        Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}