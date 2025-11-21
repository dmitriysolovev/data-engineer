Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-Module -Name Az.Synapse -Force

write-host "Identifying ADLS Gen2 account"

$dataLakeAccountName = Read-Host "Type your storage account name"
$resourceGroupName = Read-Host "Type the resource group name"
$container = Read-Host "Type default synapse container name"

# Upload files
write-host "Loading data..."
$storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $dataLakeAccountName
$storageContext = $storageAccount.Context
Get-ChildItem "./data/*.csv" -File | Foreach-Object {
    write-host ""
    $file = $_.Name
    Write-Host $file
    $blobPath = "sales/csv/$file"
    Set-AzStorageBlobContent -File $_.FullName -Container $container -Blob $blobPath -Context $storageContext
}

write-host "Script completed at $(Get-Date)"