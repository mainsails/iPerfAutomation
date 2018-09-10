# iPerf Automation PowerShell Module

## Description
The iPerfAutomation module enables an easy way to bandwidth test between multiple machines :
* Automated copy, execute, stop processes for iPerf performance testing
* The ability to change TCP Window size of the tests (-w, -window iPerf parameter)
* The ability to generate an empty file of desired size and test with that (-F, --file name : client-side iPerf parameter)


## Requirements
* All Windows Client Operating Systems are supported  
   Windows 7 SP1 and Windows Server 2008R2 through to Windows 10 CB and Windows Server 2016
* PowerShell Version 4
* Administrative Rights (where applicable)


## Usage
```powershell
Start-iPerfMonitorTest -From Computer1 -To Computer2
Connecting to host Computer2, port 5201
[  4] local 192.168.0.10 port 51962 connected to 192.168.0.11 port 5201
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-1.01   sec   344 MBytes  2.85 Gbits/sec                  
[  4]   1.01-2.01   sec   379 MBytes  3.19 Gbits/sec                  
[  4]   2.01-3.01   sec   382 MBytes  3.21 Gbits/sec                  
[  4]   3.01-4.01   sec   359 MBytes  3.02 Gbits/sec                  
[  4]   4.01-5.01   sec   362 MBytes  3.04 Gbits/sec                  
[  4]   5.01-6.01   sec   380 MBytes  3.19 Gbits/sec                  
[  4]   6.01-7.00   sec   373 MBytes  3.14 Gbits/sec                  
[  4]   7.00-8.00   sec   360 MBytes  3.02 Gbits/sec                  
[  4]   8.00-9.00   sec   319 MBytes  2.68 Gbits/sec                  
[  4]   9.00-10.02  sec   333 MBytes  2.75 Gbits/sec                  
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth
[  4]   0.00-10.02  sec  3.51 GBytes  3.01 Gbits/sec                  sender
[  4]   0.00-10.02  sec  3.51 GBytes  3.01 Gbits/sec                  receiver
```