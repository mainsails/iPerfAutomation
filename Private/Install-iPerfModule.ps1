Function Install-iPerfModule {
    [OutputType([void])]
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
            $ModulePath = ConvertTo-UNCPath -LocalFilePath 'C:\Program Files\WindowsPowerShell\Modules' -ComputerName $ComputerName
            If ($PSScriptRoot -eq 'iPerfAutomation') {
                $Path = $PSScriptRoot
            }
            Else {
                $Path = $PSScriptRoot | Split-Path -Parent
            }
            Write-Verbose -Message "Copying iPerf module to [$($ModulePath)] from [$Path])]"
            Copy-Item -Path $Path -Destination $ModulePath -Recurse -Force
        }
        Catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}