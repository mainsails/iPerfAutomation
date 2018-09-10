Function Start-iPerfMonitorTest {
    <#
    .SYNOPSIS
        Invoke iPerf between computers.
    .DESCRIPTION
        This Function invokes iPerf3 on a computer, bandwidth testing between itself and one (or many) others and then returning the results.
    .PARAMETER From
        Specifies the computer to run iPerf in Client mode.
    .PARAMETER To
        Specifies the computer[s] to run iPerf in Server mode.
    .PARAMETER WindowSize
        Sets the socket buffer (TCP window) sizes to the specified value in KB.
    .PARAMETER FileSize
        Use a generated stream of a specific size (in MB) to measure bandwidth.
    .EXAMPLE
        Start-iPerfMonitorTest -From Computer1 -To Computer2
    .EXAMPLE
        Start-iPerfMonitorTest -From Computer1 -To Computer2,Computer3,Computer4 -WindowsSize 128KB -FileSize 500MB
    #>

    [OutputType([void])]
    [CmdletBinding()]
    Param (
        [ValidateNotNullOrEmpty()]
        [string]$From,
        [ValidateNotNullOrEmpty()]
        [string[]]$To,
        [Parameter()]
        [ValidateScript({
            If ($_ -notmatch 'KB$') {
                Throw "FileSize must end with 'KB' to indicate kilobytes"
            }
            Else { $true }
        })]
        [string]$WindowSize = '1024KB',
        [Parameter()]
        [ValidateScript({
            If ($_ -notmatch 'MB$') {
                Throw "FileSize must end with 'MB' to indicate megabytes"
            }
            Else { $true }
        })]
        [string]$FileSize
    )

    Begin {
        $ErrorActionPreference = 'Stop'
    }
    Process {
        Try {
            ## Ensure all servers are available
            If ($NotAvail = @(Test-ServerAvailability -ComputerName (@($From) + $To)).where({ -not $_.Online })) {
                Throw "The server(s) [$(($NotAvail.ComputerName -join ','))] could not be contacted."
            }

            ## Ensure the iPerf module is installed on all servers
            $ServerNames = @($From) + $To
            $ServerNames | ForEach-Object {
                Install-iPerfModule -ComputerName $_
            }

            ## Ensure all To Servers have a server instance running
            If ($NoServers = @($To).where({ -not (Test-iPerfServerSession -ComputerName $_) })) {
                $NoServers | ForEach-Object {
                    Write-Verbose -Message "iPerf server not running on [$($_)]. Starting server..."
                    Start-iPerfServer -ComputerName $_
                }
            }

            ## Create the test file and copy it to clients, if necessary
            If ($PSBoundParameters.ContainsKey('FileSize')) {
                $TestFile = New-TestFile
                $LocalTestFilePath = 'C:\{0}' -f $TestFile.Name
                $CopiedTestFiles = [System.Collections.ArrayList]@()
                @($From).ForEach({
                      $UNCTestFilePath = ConvertTo-UNCPath -LocalFilePath $localTestFilePath -ComputerName $_
                      Write-Verbose -Message "Copying test file [$($testFile.FullName)] to $UNCTestFilePath..."
                      $null = $CopiedTestFiles.Add((Copy-Item -Path $TestFile.FullName -Destination $UNCTestFilePath -PassThru))
                })
            }

            $To | ForEach-Object {
                $iPerfArgs = ('-c {0} -w {1}' -f $_, $WindowSize)
                If ($PSBoundParameters.ContainsKey('FileSize')) {
                    $iPerfArgs += " -F `"$localTestFilePath`""
                }
                Invoke-iPerf -ComputerName $From -Arguments $iPerfArgs
            }
        }
        Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        Finally {
            Stop-iPerfServer -ComputerName $To
            If (Get-Variable -Name testFile -ErrorAction Ignore) {
                Write-Verbose -Message "Removing local test file [$($TestFile.FullName)]"
                Remove-Item -Path $TestFile.FullName -ErrorAction Ignore
            }

            If (Get-Variable -Name copiedTestFiles -ErrorAction Ignore) {
                Write-Verbose -Message "Removing copied test files [$($CopiedTestFiles.FullName -join ',')]"
                Remove-Item -Path $CopiedTestFiles.FullName -ErrorAction Ignore
            }
        }
    }
}