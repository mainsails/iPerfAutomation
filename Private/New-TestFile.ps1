Function New-TestFile {
    [OutputType([System.IO.FileInfo])]
    [CmdletBinding()]
    Param ()

    $TestFilePath = "$env:TEMP\TestFile.txt"
    $File = [IO.File]::Create($TestFilePath)
    $File.SetLength((Invoke-Expression -Command $FileSize))
    $File.Close()
    Get-Item -Path $TestFilePath
}