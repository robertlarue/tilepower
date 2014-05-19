[cmdletbinding()]
param([string]$vc, [string]$u, [string]$p, [string]$t, [switch]$h)

If( (Get-PSsnapin -Name VMware.VimAutomation.Core -erroraction SilentlyContinue) -eq $null){ add-pssnapin VMware.VimAutomation.Core}
. 'C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\scripts\Initialize-PowerCLIEnvironment.ps1'

#Parse $t tile number switch
#==================================================
If($t -match '-') #look for range indicator hyphen
{
 $rangearray = $t.Split("-")
 $x=0
 For($i=0; $i -lt [int]$rangearray[1]-[int]$rangearray[0]+1; $i++)
 {
 $tilearray += @([int]$rangearray[0]+$x)
 $x++
 }
}
ElseIf($t -match ',') #look for comma separated list of tiles
{
 $tilearray = $t.Split(",")
}
Else{$tilearray=$t} #single tile

#Connect to vCenter
#==================================================

Connect-VIServer $vc -User $u -Password $p

#Turn on/off VMs in Tiles
#==================================================
For($i=0; $i -lt $tilearray.Length; $i++)
{
    $tile = [string]::Concat("Tile", $tilearray[$i])
    Write-Host "Applying Power Settings to $tile"
    $vms = Get-VM -Location $tile
    ForEach($vm in $vms)                 # Start each VM in the folder
    {
        $vm_view = $vm | get-view
        Write-Host $vm_view.runtime.powerState
        If($h)
        {
            If($vm_view.runtime.powerstate -eq "poweredOn")
            {
            $vmtoolsstatus = $vm_view.summary.guest.toolsRunningStatus
            Write-Host “VM $vm VMware tools status is $Vmtoolsstatus”
            if ($vmtoolsstatus -eq “guestToolsRunning”)
            {
            Shutdown-VMGuest -VM $vm -Confirm:$false       # Shutting down VMGuest gracefully
            }
            else
            {
            Stop-VM -RunAsync -VM $vm -Confirm:$false      # Stopping the VM
            }
            }
        }
        else
        {    
        If($vm_view.runtime.powerstate -eq "poweredOff")
        {
        start-vm -RunAsync -VM $vm -Confirm:$false
        echo "Starting VM: $vm"
        }
        }
    }
}
