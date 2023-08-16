Import-Module DFSR
$replicationGroupName = "repgrp14"
$domainName = "win.mykronos.com"
$serverNames = "WIN-DFS01", "WIN-DFS02", "WIN-DFS03"
$topologyType = "FullMesh"
$primaryMember = "WIN-DFS01"
$folderName = "p14-app"
$namespace="testnamespc14"
$node1 = "WIN-DFS01"
$node2 = "WIN-DFS02"
$node3 = "WIN-DFS03"
$dnssuffix = "int.oss.mykronos.com"

foreach ($server in $serverNames) {
    Install-windowsfeature FS-DFS-Namespace, FS-DFS-Replication -IncludeManagementTools -restart
}

New-Item -ItemType Directory -Path "C:\DFSRoots\$namespace" 
New-SmbShare -Name "$namespace" -Path "C:\DFSRoots\$namespace" -FullAccess "Everyone"
New-DfsnRoot -TargetPath "\\$node1.$dnssuffix\$namespace" -Type DomainV2 -Path "\\$domainName\$namespace" 
mkdir C:\$folderName
New-SmbShare –Name $folderName –Path C:\$folderName -FullAccess "Everyone"
New-DfsnFolder -Path "\\$domainName\$namespace\$folderName" -TargetPath "\\$node1\$folderName" -EnableTargetFailback $True



New-DfsReplicationGroup -GroupName $replicationGroupName -DomainName $domainName

foreach ($server in $serverNames) {
    Add-DfsrMember -GroupName $replicationGroupName -ComputerName $server
}


Add-DfsrConnection -DestinationComputerName $node2 -GroupName $replicationGroupName -SourceComputerName $node1
Add-DfsrConnection -DestinationComputerName $node3 -GroupName $replicationGroupName -SourceComputerName $node1
Add-DfsrConnection -DestinationComputerName $node3 -GroupName $replicationGroupName -SourceComputerName $node2
Add-DfsrConnection -DestinationComputerName $node1 -GroupName $replicationGroupName -SourceComputerName $node2
Add-DfsrConnection -DestinationComputerName $node1 -GroupName $replicationGroupName -SourceComputerName $node3
Add-DfsrConnection -DestinationComputerName $node2 -GroupName $replicationGroupName -SourceComputerName $node3
New-DfsReplicatedFolder -FolderName "$folderName" -GroupName "$replicationGroupName" -DfsnPath "\\$domainName\$namespace\$folderName"
Set-DfsrMembership -ComputerName $node1 -FolderName $folderName -GroupName $replicationGroupName -ContentPath "C:\$folderName" -PrimaryMember $true -Force
Set-DfsrMembership -ComputerName $node2 -FolderName $folderName -GroupName $replicationGroupName -ContentPath "C:\$folderName" -Force
Set-DfsrMembership -ComputerName $node3 -FolderName $folderName -GroupName $replicationGroupName -ContentPath "C:\$folderName" -Force
