# Setup the AI-in-a-Day workspace

## Task 1 - Create resources

1. Create a new resource group with the `AI-in-a-Day` prefix.

2. In the resource group, create a new **Azure Cognitive Search** service with the B (Basic) pricing tier. Name the service with the `aiinaday` prefix to simplify referring to the service in the lab instructions.

3. In the resource group, create a new **Language Understanding** service. Select F0 (Free) pricing tier for both **Authoring** and **Prediction** Resources. Name the service with the `aiinaday-luis` prefix to simplify referring to the service in the lab instructions. Make sure both authoring and prediction services are deployed to the same location.

## Task 2 - Upload the data used in the lab

1. In order to create the Azure Cognitive Search Index and populate the Index with the documents run the Powershell script in [artifacts/05/azure-search-index-restore.ps1](artifacts/05/azure-search-index-restore.ps1)

## Task 3 - Lab Virtual Machine Dependencies

1. Install [.NET Core SDK 3.1](https://dotnet.microsoft.com/download/dotnet-core/thank-you/sdk-3.1.404-windows-x64-installer
)

2.  Install [Bot Framework Emulator](https://github.com/microsoft/BotFramework-Emulator/releases/latest) and make sure the shortcut for the Bot Framework Emulator in on desktop.

2. Install [Bot Framework Composer](https://docs.microsoft.com/en-us/composer/install-composer) and make sure the shortcut for the Bot Framework Emulator in on desktop.