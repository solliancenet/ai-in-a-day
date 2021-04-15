# Setup for Lab 06

## Task 1 - Deploy Azure Cognitive Services Metrics Advisior instance

## Task 2 - Deploy Azure Machine Learning workspace

## Task 3 - Copy notebooks to the AML workspace

1. In the Jupyter notebook environment, navigate to the folder associated with your lab user.

2. If the folder does not contain any notebooks, download the following items to your local machine:

[Prepare metrics feed data](https://solliancepublicdata.blob.core.windows.net/ai-in-a-day/lab-06/preparemetricsfeeddata.ipynb)

Upload the file by selecting the `Upload` button from the top right corner of the screen, and then selecting the blue `Upload` button to confirm. 

## Task 4 - Prepare Azure Machine Learning workspace

1. Open the [Azure Portal](https://portal.azure.com) and sign-in with your lab credentials.

2. In the list of your recent resources, locate the Azure Machine Learning workspace, select it, and then select `Launch studio`. If you are prompted to sign-in again, use the same lab credentials you used at the previous step.

    ![Open Azure Machine Learning Workspace](../06-metrics-advisor/media/start-aml-workspace.png)

3. In Azure Machine Learning Studio, select `Compute` from the left side menu and verify that your compute instance is running.

    ![Verify Azure Machine Learning compute instance is running](../06-metrics-advisor/media/check-aml-compute-instance.png)

>Note:
>
>If you launched Azure Machine Learning Studio right after your lab environment was provisioned, you might find the compute instance in a provisioning state. In this case, wait a few minutes until it changes its status to `Running`.

4. From the `Application URI` section associated with the compute instance, select `Jupyter`.

5. In the Jupyter notebook environment, navigate to the folder associated with your lab user. (Note that in some pre-created environments, the user folder is missing when you first access the Jupyter notebook environment, so you can work directly in the root folder where you should find / download the notebooks needed for the lab.)

    ![Navigate to user folder in Jupyter environment](../06-metrics-advisor/media/jupyter-user-folder.png)

6. Once the files is uploaded, return to the Azure Portal and select the storage account named `aiinadaystorageXXXXXX`.

    ![Locate storage account in Azure Portal](../06-metrics-advisor/media/datastore-01.png)

7. Select `Containers` and then select `+ Container` to create a new blob storage container.

    ![Create new blob storage container](../06-metrics-advisor/media/datastore-02.png)

8. Enter `jsonmetrics` as the name, keep all other settings default, and then select `Create` to create the new container.

9.  Select `Access keys` from the left side menu, and then select `Show keys`. Save the storage account name, the `key1 Key` value, and the `key1 - Connection string` value for later use.

    ![Storage account name and key](../06-metrics-advisor/media/datastore-03.png)

## Task 5 - Prepare the COVID cases per age group dataset

1. With the Azure Machine Learning studio and the Jupyter notebook environment open, select the `preparemetricsfeeddata.ipynb` notebook.

   Make sure you replace the `<BLOBSTORAGE_ACCOUNT_NAME>` and `<BLOBSTORAGE_ACCOUNT_KEY>` values in the variable initialization cell with the values you have noted down at the end of the previous task.

   The notebook will guide you through a list of steps needed to prepare a time series-based dataset containing JSON files to be fed into the Metrics Advisor workspace. Each JSON file will contain daily data representing the count of COVID positive cases by age group.

2. Execute the notebook cell by cell (using either Ctrl + Enter to stay on the same cell, or Shift + Enter to advance to the next cell) and observe the results of each cell execution.