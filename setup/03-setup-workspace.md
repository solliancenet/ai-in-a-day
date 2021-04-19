# Setup the Lab 03 AI-in-a-Day workspace

## Task 1 - Create resources

1. If it does not already exist, create a new resource group with the `AI-in-a-Day` prefix.

2. In the resource group, create a new [**Azure Cognitive Search** service](https://portal.azure.com/#create/Microsoft.Search) with the B (Basic) pricing tier. Name the service with the `aiinaday` prefix to simplify referring to the service in the lab instructions.

3. In the resource group, create a new [**Azure Cognitive Services** service](https://portal.azure.com/#create/Microsoft.CognitiveServicesAllInOne). Select the S0 (Standard) pricing tier. Name the service with the `aiinaday-cogsvc` prefix to simplify referring to the service in the lab instructions.

4. In the resource group, create a new **Storage Account** service if one does not already exist. Name the service with the `aiinaday-storage` prefix to simplify referring to the service in the lab instructions.

## Task 2 - Upload the data used in the lab

1. Ensure that the storage account has a `covid19temp` container, which should include two folders:  `comm_use_subset` and `papers`.  Inside `comm_use_subset` there should be a `pdf_json` folder which contains 865 PDFs, as well as a `pdf_json_refresh` folder which contains 100 PDFs.  Inside `papers`, there should be 10 PDFs.

## Task 3 - Lab Virtual Machine Dependencies

1. Install [Python 3.9](https://www.python.org/downloads/) or later.

2. Add Python39 to the path.  For the `demouser` account and Python 3.9, this would be `C:\Users\demouser\AppData\Local\Programs\Python\Python39\`.

3. Ensure that PowerShell version 5 or later is installed.

4. Install [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/).
