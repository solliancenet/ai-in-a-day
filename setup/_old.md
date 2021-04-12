## Setup and Define Triggers

### Events that trigger workflow

Github workflows are triggered based on events specified inside workflows. These events can be from inside the github repo like a push commit or can be from outside like a webhook([repository-dispatch](https://docs.github.com/en/developers/webhooks-and-events/webhook-events-and-payloads#repository_dispatch)).
Refer [link](https://docs.github.com/en/actions/reference/events-that-trigger-workflows) for more details on configuring your workflows to run on specific events.


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
| `COVID19Articles_GH`                        | Sample data science source code that will be submitted to Azure Machine Learning to train and deploy machine learning models. |
| `COVID19Articles_GH/train`                  | Sample code that is required for training a model on Azure Machine Learning. |
| `COVID19Articles_GH/train/train_aml.py`         | Training script that gets executed on a cluster on Azure Machine Learning. |
| `COVID19Articles_GH/train/environment.yml`  | Conda environment specification, which describes the dependencies of `train_aml.py`. These packages will be installed inside a Docker image on the Azure Machine Learning compute cluster, when executing your `train_aml.py`. |
| `COVID19Articles_GH/train/run_config.yml`   | YAML files, which describes the execution of your training run on Azure Machine Learning. This file also references your `environment.yml`. Please look at the comments in the file for more details. |
| `COVID19Articles_GH/deploy`                 | Sample code that is required for deploying a model on Azure Machine Learning. |
| `COVID19Articles_GH/deploy/score.py`        | Inference script that is used to build a Docker image and that gets executed within the container when you send data to the deployed model on Azure Machine Learning. |
| `COVID19Articles_GH/deploy/environment.yml` | Conda environment specification, which describes the dependencies of `score.py`. These packages will be installed inside the Docker image that will be used for deploying your model. |
| `COVID19Articles_GH/test/test.py`           | Test script that can be used for testing your deployed webservice. Add a `deploy.json` to the `.cloud/.azure` folder and add the following code `{ "test_enabled": true }` to enable tests of your webservice. Change the code according to the tests that zou would like to execute. |
| `.cloud/.azure`               | Configuration files for the Azure Machine Learning GitHub Actions. Please visit the repositories of the respective actions and read the documentation for more details. |
| `.github/workflows`           | Folder for GitHub workflows. The `train_deploy.yml` sample workflow shows you how your can use the Azure Machine Learning GitHub Actions to automate the machine learning process. |



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



# Setup Azure DevOps

Setup an Azure DevOps project in an Azure DevOps tenant.


