# ML Ops with GitHub Actions and AML

<p align="center">
  <img src="./media/aml_logo.png" height="80"/>
  <img src="https://i.ya-webdesign.com/images/a-plus-png-2.png" alt="plus" height="40"/>
  <img src="./media/github_action_logo.png" alt="Azure Machine Learning + Actions" height="80"/>
</p>

This task shows how to perform DevOps for Machine learning applications using [Azure Machine Learning](https://docs.microsoft.com/en-us/azure/machine-learning/) powered [GitHub Actions](). Using this approach, you will be able to setup your train and deployment infrastructure, train the model and deploy them in an automated manner.

1. Sign-in to GitHub with your GitHub account.

2. Navigate to the [MLOpsPython](https://github.com/microsoft/MLOpsPython) template repository and select `Use this template` to provision your GitHub project.

    ![Clone GitHub template repository](./../media/clone-github-template.png)

### 3. Setting up the required secrets

#### To allow GitHub Actions to access Azure
An [Azure service principal](https://docs.microsoft.com/en-us/azure/active-directory/develop/app-objects-and-service-principals) needs to be generated. Just go to the Azure Portal to find the details of your resource group. Then start the Cloud CLI or install the [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) on your computer and execute the following command to generate the required credentials:

```sh
# Replace {service-principal-name}, {subscription-id} and {resource-group} with your 
# Azure subscription id and resource group name and any name for your service principle
az ad sp create-for-rbac --name {service-principal-name} \
                         --role contributor \
                         --scopes /subscriptions/{subscription-id}/resourceGroups/{resource-group} \
                         --sdk-auth
```

This will generate the following JSON output:

```sh
{
  "clientId": "<GUID>",
  "clientSecret": "<GUID>",
  "subscriptionId": "<GUID>",
  "tenantId": "<GUID>",
  (...)
}
```

Add this JSON output as [a secret](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets) with the name `AZURE_CREDENTIALS` in your GitHub repository:

<p align="center">
  <img src="media/02-setup-03.png" alt="GitHub Template repository" width="700"/>
</p>

To do so, click on the Settings tab in your repository, then click on Secrets and finally add the new secret with the name `AZURE_CREDENTIALS` to your repository.

Please follow [this link](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets) for more details. 

#### To allow Azure to trigger a GitHub Workflow
 We also need GH PAT token with `repo` access so that we can trigger a GH workflow when the training is completed on Azure Machine Learning. 
 
 <p align="center">
  <img src="media/02-setup-04.png" alt="GitHub Template repository" width="700"/>
</p>
 
 Add the PAT token with as [a secret](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets#creating-encrypted-secrets) with the name `PATTOKEN` in your GitHub repository:
 <p align="center">
  <img src="media/02-setup-05.png" alt="GitHub Template repository" width="700"/>
</p>

### 4. Setup and Define Triggers

#### Events that trigger workflow
Github workflows are triggered based on events specified inside workflows. These events can be from inside the github repo like a push commit or can be from outside like a webhook([repository-dispatch](https://docs.github.com/en/developers/webhooks-and-events/webhook-events-and-payloads#repository_dispatch)).
Refer [link](https://docs.github.com/en/actions/reference/events-that-trigger-workflows) for more details on configuring your workflows to run on specific events.

#### Setup Trigger

We have precreated a GitHub workflow `setup.yml` that does the infrastructure creation. To trigger this workflow follow the below steps-
- Update parameter 'resource_group' value in file [workspace.json](/.cloud/.azure/workspace.json) to your resource group name.
- Update environment variable 'RESOURCE_GROUP' in [setup.yml](/.github/workflows/setup.yml) workflow.   Make sure your resource group name in [workspace.json](/.cloud/.azure/workspace.json) is same as that in [setup.yml](/.github/workflows/setup.yml). Committing this file will trigger this workflow and do the required setup.

Check the actions tab to view if your workflows have successfully run.

<p align="center">
  <img src="media/02-setup-06.png" alt="GitHub Actions Tab" width="700"/>
</p>

#### Define Trigger
We have created sample workflow file [deploy_model](/.github/workflows/deploy_model.yml) that gets triggered on repository dispatch event `machinelearningservices-runcompleted` as defined [here](/.github/workflows/deploy_model.yml#L4) . This workflow deploys trained model to azure kubernetes.

If you add this repository dispatch event `machinelearningservices-runcompleted` in other workflows, they will also start listening to the machine learning workspace events from  the subscribed workspace.



### 5. Testing the trigger

We have created sample workflow file [train_model.yml](/.github/workflows/train_model.yml) to train the model. You need to update this workflow file [train_model.yml](/.github/workflows/train_model.yml)  by doing a commit to  this file or to any file under 'code/' folder.

This workflow trains the model and on successful training completion triggers  workflow [deploy_model](/.github/workflows/deploy_model.yml) that deploys the model.

### 6. Review 

Any change to training file [train.py](https://github.com/Azure-Samples/mlops-enterprise-template/blob/main/code/train/train.py) will trigger workflow [train_model.yml](/.github/workflows/train_model.yml) and train the model using updated training code.
After this training completes [deploy_model.yml](/.github/workflows/deploy_model.yml ) will automatically be triggered and deploy model to the AKS instance.

The log outputs of this workflow [deploy_model.yml](/.github/workflows/deploy_model.yml ) run will provide URLs for you to get the service endpoints deployed on kubernetes. 


### 7. Next Steps: Add Storage Triggers

As next steps, you can setup similar triggers on updates to [Azure Storage](https://azure.microsoft.com/en-gb/services/storage/) account. So, if you are using Azure Storage for storing your training data any update to the data will auto trigger the training on new data and will auto deploy the updated model too. 

You would need an Azure Storage account in the same resource group as above.  To create a new storage account use [link](https://ms.portal.azure.com/#create/Microsoft.StorageAccount-ARM). 

Follow there two steps to enable triggerring of GitHub Workflows on Storage Account updates. 
- Remove comments in [deploy.core-infra.json](/infra/deploy.core-infra.json) (  [line 562](/infra/deploy.core-infra.json#L562) and [line 600](/infra/deploy.core-infra.json#L562)).
- Update `STORAGE_ACCOUNT` variable in [setup.yml](/.github/workflows/setup.yml) with the Storage Name you created above. 

A commit to setup.yml will enable [train_model.yml](/.github/workflows/train_model.yml) to be executed on any change in Storage Account. 



## Documentation

### Code structure

| File/folder                   | Description                                |
| ----------------------------- | ------------------------------------------ |
| `code`                        | Sample data science source code that will be submitted to Azure Machine Learning to train and deploy machine learning models. |
| `code/train`                  | Sample code that is required for training a model on Azure Machine Learning. |
| `code/train/train.py`         | Training script that gets executed on a cluster on Azure Machine Learning. |
| `code/train/environment.yml`  | Conda environment specification, which describes the dependencies of `train.py`. These packages will be installed inside a Docker image on the Azure Machine Learning compute cluster, when executing your `train.py`. |
| `code/train/run_config.yml`   | YAML files, which describes the execution of your training run on Azure Machine Learning. This file also references your `environment.yml`. Please look at the comments in the file for more details. |
| `code/deploy`                 | Sample code that is required for deploying a model on Azure Machine Learning. |
| `code/deploy/score.py`        | Inference script that is used to build a Docker image and that gets executed within the container when you send data to the deployed model on Azure Machine Learning. |
| `code/deploy/environment.yml` | Conda environment specification, which describes the dependencies of `score.py`. These packages will be installed inside the Docker image that will be used for deploying your model. |
| `code/test/test.py`           | Test script that can be used for testing your deployed webservice. Add a `deploy.json` to the `.cloud/.azure` folder and add the following code `{ "test_enabled": true }` to enable tests of your webservice. Change the code according to the tests that zou would like to execute. |
| `.cloud/.azure`               | Configuration files for the Azure Machine Learning GitHub Actions. Please visit the repositories of the respective actions and read the documentation for more details. |
| `.github/workflows`           | Folder for GitHub workflows. The `train_deploy.yml` sample workflow shows you how your can use the Azure Machine Learning GitHub Actions to automate the machine learning process. |
| `docs`                        | Resources for this README.                 |
| `CODE_OF_CONDUCT.md`          | Microsoft Open Source Code of Conduct.     |
| `LICENSE`                     | The license for the sample.                |
| `README.md`                   | This README file.                          |
| `SECURITY.md`                 | Microsoft Security README.                 |


### Documentation of Azure Machine Learning GitHub Actions

The template uses the open source Azure certified Actions listed below. Click on the links and read the README files for more details.
- [aml-workspace](https://github.com/Azure/aml-workspace) - Connects to or creates a new workspace
- [aml-compute](https://github.com/Azure/aml-compute) - Connects to or creates a new compute target in Azure Machine Learning
- [aml-run](https://github.com/Azure/aml-run) - Submits a ScriptRun, an Estimator or a Pipeline to Azure Machine Learning
- [aml-registermodel](https://github.com/Azure/aml-registermodel) - Registers a model to Azure Machine Learning
- [aml-deploy](https://github.com/Azure/aml-deploy) - Deploys a model and creates an endpoint for the model


### ARM template to deploy azure resources
The workflow file 'setup.yml' deploys arm template to azure using standard azure CLI deploy command.
Arm Template [deploy.core-infra.json](/infra/deploy.core-infra.json) is used to deploy azure resources to azure . It uses the parameters provided in file [deploy.core-infra.params.json](/infra/params.deploy.core-infra.json)  to create new resources or update the resources if they are already present.

### Documentation of template file parameters

| Parameter                  | Description                                |
| ----------------------------- | ------------------------------------------ |
| `workspaceName`                        | Specifies the name of the Azure Machine Learning workspace.If the resource doesn't exist a new workspace will be created, else existing resource will be updated using the arm template file |
| `baseName`                  | Name used as base-template to name the resources to be deployed in Azure. |
| `OwnerName`         | Owner of this deployment, person to contact for question. |
| `GitHubBranch`  | Name of the branch containing azure function code. |
| `eventGridTopicPrefix`   | The name of the Event Grid custom topic. |
| `eventGridSubscriptionName`                 | The prefix of the Event Grid custom topic's subscription. |
| `FunctionName`        |name of azure function used|
| `subscriptionID` | azure subscription ID being used for deployment |
| `GitHubURL`           | The URL of GitHub (ending by .git) containing azure function code. |
| `funcProjectFolder`               | The name of folder containing the function code. |
| `repo_name`           | The name of repository containing template files.This is picked up from github environment parameter 'GITHUB_REPOSITORY' |
| `pat_token`                        | pat token to be used by the function app to communicate to github via repository dispatch. |


### Event Grid Subscription
User can modify the deploy_event_grid.json arm template to add/remove the storage events that he/she 
wants to subscribe to [here](https://github.com/Azure-Samples/mlops-enterprise-template/blob/eb32e4df6e9124777e9d5216a7b3841992f03924/infra/deploy.core-infra.json#L526). These are the available events from storage account :
```sh

Microsoft.Storage.BlobCreated
Microsoft.Storage.BlobDeleted
Microsoft.Storage.BlobRenamed
Microsoft.Storage.DirectoryCreated
Microsoft.Storage.DirectoryRenamed
Microsoft.Storage.DirectoryDeleted

```

### Known issues

#### Error: MissingSubscriptionRegistration

Error message: 
```sh
Message: ***'error': ***'code': 'MissingSubscriptionRegistration', 'message': "The subscription is not registered to use namespace 'Microsoft.KeyVault'. See https://aka.ms/rps-not-found for how to register subscriptions.", 'details': [***'code': 'MissingSubscriptionRegistration', 'target': 'Microsoft.KeyVault', 'message': "The subscription is not registered to use namespace 'Microsoft.KeyVault'. See https://aka.ms/rps-not-found for how to register subscriptions
```
Solution:

This error message appears, in case the `Azure/aml-workspace` action tries to create a new Azure Machine Learning workspace in your resource group and you have never deployed a Key Vault in the subscription before. We recommend to create an Azure Machine Learning workspace manually in the Azure Portal. Follow the [steps on this website](https://docs.microsoft.com/en-us/azure/machine-learning/tutorial-1st-experiment-sdk-setup#create-a-workspace) to create a new workspace with the desired name. After ou have successfully completed the steps, you have to make sure, that your Service Principal has access to the resource group and that the details in your <a href="/.cloud/.azure/workspace.json">`/.cloud/.azure/workspace.json"` file</a> are correct and point to the right workspace and resource group.


# Setup Azure DevOps

Setup an Azure DevOps project in an Azure DevOps tenant.



# What is MLOps?

<p align="center">
  <img src="media/02-setup-07.png" alt="Azure Machine Learning Lifecycle" width="700"/>
</p>

MLOps empowers data scientists and machine learning engineers to bring together their knowledge and skills to simplify the process of going from model development to release/deployment. ML Ops enables you to track, version, test, certify and reuse assets in every part of the machine learning lifecycle and provides orchestration services to streamline managing this lifecycle. This allows practitioners to automate the end to end machine Learning lifecycle to frequently update models, test new models, and continuously roll out new ML models alongside your other applications and services.

This repository enables Data Scientists to focus on the training and deployment code of their machine learning project (`code` folder of this repository). Once new code is checked into the `code` folder of the master branch of this repository the GitHub workflow is triggered and open source Azure Machine Learning actions are used to automatically manage the training through to deployment phases.


