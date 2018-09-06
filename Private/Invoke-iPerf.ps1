Function Invoke-iPerf {
    [OutputType([void])]
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string[]]$ComputerName,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Arguments
    )

    Begin {
        $ErrorActionPreference = 'Stop'
    }
    Process {
        Try {
            $iPerfServerFilePath = Join-Path -Path $iPerfServerFolderPath -ChildPath $iPerfFileName
            $Mode = Convert-ArgumentToMode -iPerfArgs $Arguments
            $icmParams = @{
                ComputerName = $ComputerName
                ArgumentList = $iPerfServerFilePath, $Arguments
            }
            If ($Mode -eq 'Server') {
                ## Do not invoke server mode for servers that already have it running
                If ($RunningServers = @($ComputerName).where({ Test-iPerfServerSession -ComputerName $_ })) {
                    Write-Verbose -Message "The server(s) [$(($runningServers -join ','))] are already running."
                    [string[]]$ComputerName = @($ComputerName).where({ $_ -notin $RunningServers })
                }
                $icmParams.InDisconnectedSession = $true
            }
            Write-Verbose -Message "Invoking iPerf in [$($mode)] mode on computer(s) [$ComputerName] using args [$($Arguments)]..."
            $ComputerName | ForEach-Object {
                If ($Mode -eq 'Server') {
                    $icmParams.SessionName = "$_ - $mode - $InvokeiPerfPSSessionSuffix"
                }
                Invoke-Command @icmParams -ScriptBlock {
                    $VerbosePreference = 'Continue'
                    $FileShortPath = (New-Object -com scripting.filesystemobject).GetFile($args[0]).ShortPath
                    $CLIString = "$FileShortPath $($args[1])"
                    Invoke-Expression -Command $CLIString
                }
            }
        }
        Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}