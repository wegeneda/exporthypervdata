  get-vm  | % {
    $i=0
    $CPUcount = (get-vmprocessor -VMname $_.Name).Count
    $hyerv=$_ |Select-Object -Property Name, @{n="Memory Assigned";e={$_.memoryassigned/1mb}}, Version, Computername 
    $disks=$_.VMId | Get-VHD | select vhdtype,path,@{label='Size';expression={$_.filesize/1gb -as [int]}}
    $OSdiscspace = $disks[0].Size

    $disks | % {
        $i=$i+$_.Size
        $i=$i-$OSdiscspace
        $datadiscspace = $i
    }
    $hyerv | Add-Member -MemberType NoteProperty -Name 'CPUCores' -Value $CPUcount
    $hyerv | Add-Member -MemberType NoteProperty -Name 'OSdiscspace in GB' -Value $OSdiscspace
    $hyerv | Add-Member -MemberType NoteProperty -Name 'DataDiscSpace in GB' -Value $datadiscspace
    $hyerv | Export-Csv C:\vms.csv -NoTypeInformation -Append -Force
 }
 
