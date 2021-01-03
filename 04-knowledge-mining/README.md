# Lab 4 - Knowledge Mining with Azure Cognitive Search and Text Analytics

TODO:  Intro

## Lab Requirements

In order to work through this lab, you will need the following tools installed:

* Python 3.  Python version 2 is not supported for this lab.
* PowerShell 5 or later.  To determine your version, open up a PowerShell prompt and enter `Get-Host`.  If the `Version` does not start with a 5 (or higher number), the PowerShell commands in this lab may not work.
* [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/).

The virtual machine which accompanies this lab will have all of these tools installed.

## Task 1 - Creating Azure Search Indexes

1. Navigate to [the Azure portal](https://portal.azure.com) and log in with your credentials.  Then, select **Resource groups**.

![Open Azure resource group](media/azure-open-resource-groups.png)

2. Select the **AI-in-a-Day** resource group.

3. Select the Storage account.

![The Storage account is highlighted from the list of services in the AI-in-a-Day Resource Group](media/select-azure-storage-account.png)

4. Navigate to the **Access keys** setting.  Then, select **Show keys** and copy the connection string for `key1`.  Paste this into a text file.

![The Storage account's access key is copied to the clipboard.](media/copy-azure-storage-account-key.png)

5. Return to the **AI-in-a-Day** resource group.  Then, select the Search service.

![The Search service is highlighted from the list of services in the AI-in-a-Day Resource Group](media/select-azure-search-service.png)

6. Copy the search service URL and paste this into a text file.  Also make note of the service account name, which comes before `.search.windows.net`.

![The Search service's URL is copied to the clipboard.](media/copy-azure-search-url.png)

7. Navigate to the Keys setting and copy the Primary admin key.  Paste this into a text file.

![The Search service's API key is copied to the clipboard.](media/copy-azure-search-api-key.png)

8. Download the files in the `schemas\` folder.  There are six files, three prefixed with `abstracts` and three with `covid19temp`.  Save these to a directory such as `C:\Temp\AzureSearch\`.

9. Open the `abstracts_datasource.schema` file with a text editor and replace the segment starting `<< TODO:` with your Storage account connection string.  Do the same for `covid19temp_datasource.schema`.

![The abstract data source is ready to be updated.](media/edit-abstracts-datasource.png)

10. Open a new PowerShell prompt.  Enter the following code, which will create an Azure Search data source, index, and indexer.

```powershell
function Create-AzureSearchIndex {
    param
    (
        [string]$DataSourceFilePath,
        [string]$IndexFilePath,
        [string]$IndexerFilePath,
        [string]$AccountName,
        [string]$ApiKey
    )
    
    $Header = @{
        "api-key" = $ApiKey
    }
    $BaseUri = "https://" + $AccountName + ".search.windows.net"
    
    # Create Data Source
    $Uri = $BaseUri + "/datasources?api-version=2020-06-30"
    Invoke-RestMethod -Method Post -Uri $Uri -Header $header -ContentType "application/json" -InFile $DataSourceFilePath
    
    # Create Index
    $Uri = $BaseUri + "/indexes?api-version=2020-06-30"
    Invoke-RestMethod -Method Post -Uri $Uri -Header $header -ContentType "application/json" -InFile $IndexFilePath
    
    # Create Indexer
    $Uri = $BaseUri + "/indexers?api-version=2020-06-30"
    Invoke-RestMethod -Method Post -Uri $Uri -Header $header -ContentType "application/json" -InFile $IndexerFilePath
}
```

![The Create-AzureSearchIndex function has been created in PowerShell.](media/create-azuresearchindex.png)

11. In the same PowerShell prompt, call this function for the `abstracts` index and for the `covid19temp` index.  If you did not use `C:\Temp\AzureSearch\` to save your schema files, change the function call to point to the correct file location.  Then, fill in your Azure Search account name and Azure Search API key.

```powershell
Create-AzureSearchIndex "C:/Temp/AzureSearch/abstracts_datasource.schema" "C:/Temp/AzureSearch/abstracts.schema" "C:/Temp/AzureSearch/abstracts_indexer.schema" "<<ACCOUNT NAME>>" "<<API KEY>>"

Create-AzureSearchIndex "C:/Temp/AzureSearch/covid19temp_datasource.schema" "C:/Temp/AzureSearch/covid19temp.schema" "C:/Temp/AzureSearch/covid19temp_indexer.schema" "<<ACCOUNT NAME>>" "<<API KEY>>"
```

![The Create-AzureSearchIndex function has been run to create a new index.](media/create-azuresearchindex-use.png)

## Task 2 - Querying Azure Search Indexes

1. Navigate to [the Azure portal](https://portal.azure.com) and log in with your credentials.  Then, select **Resource groups**.

![Open Azure resource group](media/azure-open-resource-groups.png)

2. Select the **AI-in-a-Day** resource group.

3. Select the Search service.

![The Search service is highlighted from the list of services in the AI-in-a-Day Resource Group](media/select-azure-search-service.png)

4. Select the **Indexes** tab and ensure that you have two indexes created.  If the Document Count is 0 for either, wait a couple of minutes and select **Refresh** until the document count appears.

![The list of Azure Search indexes.](media/azure-search-indexes.png)

5. Once documents are available, select **Search Explorer** to open up the Search Explorer.

![The Search Explorer option is selected.](media/azure-search-indexes-search-explorer.png)

6. Choose the **covid19temp** index and enter `RNA interference` into the Query string input box, and then select **Search**.  This will return the documents which include the phrase "RNA interference."

![Articles with the phrase RNA intereference.](media/search-explorer-rna-interference.png)

7. We can also see how many articles match a certain search string.  In the Query string input box, enter the phrase `Brazil&$count=true` and then select **Search**.  This will return 53 documents.

![53 articles reference Brazil.](media/search-explorer-brazil-1.png)

8. Each document returns a large number of fields, but we can specify the fields we would like to see.  In the Query string input box, enter the phrase `UNC Chapel Hill&$select=metadata/authors, metadata/title` and then select **Search**.  This will return the title as well as detailed information on each author.

![Paper titles and authors referencing UNC Chapel Hill.](media/search-explorer-unc.png)

9. The Azure Search service can also generate a demo application.  Return to the search service and select the **covid19temp** index.

![The covid19temp index is selected.](media/azure-search-indexes-covid19temp.png)

10. Select the **Create Demo App** option.

![The Create Demo App option is selected.](media/create-demo-app.png)

11. On the first tab select `metadata.title` for the Title and `abstract.text` for the Description.  Then select **Create Demo App**.  After the prompt, select **Download** to download an HTML file named `AzSearch.html`.

![Create a demo app.](media/create-demo-app-1.png)

12. Open the demo app HTML file.  In the search box, enter the phrase "RNA interference" and select the Search icon.  This will return 497 papers relating to RNA interference.

![Use the demo app.](media/search-demo-app.png)

## Task 3 - Updating Azure Search Indexes

1. Open Azure Storage Explorer.  Select the **Connect** option and then choose **Use a connection string** and select **Next**.

![The Use a connection string option is selected.](media/azure-storage-explorer-connect-1.png)

2. Enter **lab04** as the Display name and paste in your storage account connection string.  Then, select **Next** to continue and **Connect** to complete the operation.

![The connection string is filled in.](media/azure-storage-explorer-connect-2.png)

3. In Azure Storage Explorer, navigate down the **lab04** attached storage and select the `covid19temp` blob container.  Double-click the **comm_use_subset** to enter that folder.

![The comm_use_subset folder is selected.](media/azure-storage-explorer-1.png)

4. Enter the **pdf_json_refresh** folder.  Then, in the **Select All** menu, choose **Select All Cached**.  This will highlight all 100 records in the folder.  Select **Copy** to copy these documents.

![Select all cached items and copy them.](media/azure-storage-explorer-2.png)

5. Navigate up to **comm_use_subset** and then double-click **pdf_json**.  Inside this folder, select **Paste** to paste the 100 documents into the **pdf_json** folder.  When it finishes, you should have 965 total documents.

![Paste all cached items into the pdf_json folder.](media/azure-storage-explorer-3.png)

6. Navigate to [the Azure portal](https://portal.azure.com) and log in with your credentials.  Then, select **Resource groups**.

![Open Azure resource group](media/azure-open-resource-groups.png)

7. Select the **AI-in-a-Day** resource group.

8. Select the Search service.

![The Search service is highlighted from the list of services in the AI-in-a-Day Resource Group](media/select-azure-search-service.png)

9. Navigate to the **Indexers** section and select the **covid19temp** indexer.

![The covid19temp indexer is selected.](media/azure-search-indexers.png)

10. Select the **Run** option to process the 100 documents.  Although we can configure an indexer to run periodically, this indexer will only run when manually engaged.  Select **Yes** to run the indexer.

![The covid19temp indexer is set to run.](media/azure-search-indexers-run.png)

11. The indexer will run.  It should complete within 15-30 seconds to process the 100 new documents.  You may need to select **Refresh** to see the indexer's progress.

![The covid19temp indexer has finished running.](media/azure-search-indexers-refresh.png)

12. Return to the **Indexes** tab for the Search service and ensure that the **covid19temp** index has 965 documents.  If it still reads 865, wait 30 seconds and select **Refresh** to check again.

![The covid19temp index has finished updating.](media/azure-search-indexes-update.png)

13. Select the **covid19temp** index to return to the Search explorer.  When we had 865 documents, 53 of them pertained to Brazil.  We can confirm that this update was successful by entering `Brazil&$count=true` and selecting **Search**.  This will now return 57 results instead of the prior 53.

![57 documents pertain to Brazil.](media/search-explorer-brazil-2.png)
