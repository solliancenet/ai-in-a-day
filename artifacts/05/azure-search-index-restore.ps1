$targetSearchServiceName = Read-Host -Prompt "Enter the name of the search service you want to script to prepopulate with data."
$targetAdminKey = Read-Host -Prompt "Enter the admin key for your search service."
$serviceUri = "https://" + $targetSearchServiceName + ".search.windows.net"

$uri = $serviceUri + "/indexes?api-version=2019-05-06"

$headers = @{
    'api-key' = $targetAdminKey
}

$indexSchemaFile = Get-Content -Raw -Path "cognitive-index.schema"

Write-Host "Creating Target Search Index."

$result = Invoke-RestMethod  -Uri $uri -Method POST -Body $indexSchemaFile -Headers $headers -ContentType "application/json"

Write-Host "Starting to upload index documents from saved JSON files."

$uri = $serviceUri + "/indexes/cognitive-index/docs/index?api-version=2019-05-06"
$files = Get-ChildItem "." -Filter *.json 
foreach ($f in $files){
    $content = Get-Content $f.FullName
    Write-Host "Uploading documents from file" $f.Name
    $result = Invoke-RestMethod  -Uri $uri -Method POST -Body $content -Headers $headers -ContentType "application/json"
}

Write-Host "Data upload completed."