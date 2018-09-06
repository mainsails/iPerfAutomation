Function Stop-iPerfServer {
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
            $icmParams = @{
                ComputerName = $ComputerName
                ScriptBlock  = { Get-Process -Name $args[0] -ErrorAction SilentlyContinue | Stop-Process }
                ArgumentList = [System.IO.Path]::GetFileNameWithoutExtension($iPerfFileName)
            }
            Invoke-Command @icmParams
        }
        Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        Finally {
            $ComputerName | ForEach-Object {
                Get-PSSession -Name "$_ - Server*" -ErrorAction SilentlyContinue | Remove-PSSession -ErrorAction SilentlyContinue
            }
        }
    }
}