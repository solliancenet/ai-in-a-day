# Lab 1 - Azure Machine Learning Model Training

In this lab, you will use Azure Machine Learning to build, train and interpret desired models. You will learn how to train a regression model against time-series data, without any code, by using automated machine learning, and how to interpret trained machine learning models. You will also learn to evaluate model fairness, and make sure that your model is not affected by hidden bias in your data.

At the end of this lab, you will be better able to build solutions leveraging Azure Machine Learning.

## Overview

Trey Research Inc. delivers innovative solutions for manufacturers. They specialize in identifying and solving problems for manufacturers that can run the range from automating away mundane but time-intensive processes to delivering cutting edge approaches that provide new opportunities for their manufacturing clients.

Trey Research is looking to provide the next generation experience for connected car manufacturers by enabling them to utilize AI to decide when to pro-actively reach out to the customer through alerts delivered directly to the car’s in-dash information and entertainment head unit. For their proof of concept (PoC), they would like to focus on one specific maintenance related scenario.

In this scenario, Trey Research would like to predict the likelihood that a car will require maintenance based on the historic data logging previous maintenance visits. The data contains details about the car owner, when it was first bought, its make and engine type, among other fields.

If they detect maintenance has a high probability of being required within the next 30 days, they would like to send an alert directly to the customer inviting them to schedule a service appointment.

In building this PoC, Trey Research wants to understand how they might use machine learning in this scenario, and standardize the platform that would support the data processing, model management and inferencing aspects of each.

Furthermore, they would also like to understand how Azure might help them to document and explain the models that are created to non-data scientists or might accelerate their time to creating production ready, performant models.

In this lab, you will use Azure Machine Learning to build, train and interpret the desired models.

## Exercise: Creating a regression model using automated machine learning

In this exercise, you will create a model that predicts need for maintenance from time-series data using the visual interface to automated machine learning in an Azure Machine Learning workspace.
### Task 1: Create an automated machine learning experiment

1. Navigate to your Azure Machine Learning workspace in the Azure Portal. Select **Launch studio**.

    ![The Azure Machine Learning workspace is displayed. The Launch studio button is selected on the Overview screen.](images/automl-open-studio.png 'Open Azure Machine Learning studio')

    > **Note**: Alternatively, you can sign-in directly to the [Azure Machine Learning studio portal](https://ml.azure.com).

2. Select **Automated ML icon** in the left navigation bar and choose **New automated ML run**.

    ![In the Automated machine learning section in Azure Machine Learning studio. The "New automated ML run" button is selected.](./images/automl-new-run.png 'Create new automated ML run')

3. Choose to **Create dataset from local files** with the info below:

    - **Basic info**
      - **Name**: `CarMaintenance`
    - **Datastore and file selection**
      - Make sure the **Currently selected datastore** option is set
      - **Browse** to the `data` folder in this repository, and select `car-maintenance-data.csv`
    - **Settings and preview**
      - **Column headers**: **Use headers from the first file**

Leave the other options set to their default values, and confirm the dataset creation.
   
4. Select the newly created `CarMaintenance` dataset from the list of registered datasets and then select **Next**.

     ![In the Create a new Automated ML run dialog, select the CarMaintenance dataset from the dataset list. The Next button is highlighted.](images/automl-create-dataset-01.png 'Select registered dataset')

5. Review the dataset details in the `Configure run` section, by selecting the **View dataset** link next to the dataset name.

    ![The Configure run screen shows the option to review the selected dataset structure. Select the view dataset link next to the dataset name.](images/automl-create-dataset-02.png 'Confirm and create the dataset')

6.  Provide the experiment name: `Car-Maintenance` and select **car-age-in-months** as target column. Select **Create a new compute**.

    ![In the Configure run form is populated with the above values. The Create a new compute button is highlighted.](images/automl-create-experiment.png 'Create New Experiment details')

7.  For the new compute, provide the following values and then select **Create**:

    - **Compute name**: `auto-ml-compute`
  
    - **Select Virtual Machine size**: `STANDARD_DS3_v2`
  
    - **Minimum number of nodes**: `0`
  
    - **Maximum number of nodes**: `1`

    ![The New Training Cluster form is populated with the above values. The Create button is selected at the bottom of the form.](images/automl-create-compute.png 'Create a New Compute')

    > **Note**: The creation of the new compute may take several minutes. Once the process is completed, select **Next** in the `Configure run` section.

8.  Select the `Regression` task type and then select **View additional configuration settings**:

    ![The Select task type form is populated with the values outlined above. The View additional configuration settings link is highlighted.](images/automl-configure-task-01.png 'Configure time series forecasting task')

9.  For the automated machine learning run additional configurations, provide the following values and then select **Save**:

    - **Primary metric**: `Normalized root mean squared error`

    - **Training job time (hours)** (in the `Exit criterion` section): enter `1` as this is the lowest value currently accepted.

    - **Metric score threshold**: enter `0.1355`. When this threshold value will be reached for an iteration metric the training job will terminate.

    ![The Additional configurations form is populated with the values defined above. The Save button is highlighted at the bottom of the form.](images/automl-configure-task-02.png 'Configure automated machine learning run additional configurations')

    > **Note**: We are setting a metric score threshold to limit the training time. In practice, for initial experiments, you will typically only set the training job time to allow AutoML to discover the best algorithm to use for your specific data.

10. Select **Finish** to start the new automated machine learning run.

    > **Note**: The experiment should run for up to 10 minutes. If the run time exceeds 15 minutes, cancel the run and start a new one (steps 3, 9, 10). Make sure you provide a higher value for `Metric score threshold` in step 10.

### Task 2: Review the experiment run results

1. Once the experiment completes, select `Details` to examine the details of the run containing information about the best model and the run summary.

   ![The Run Detail screen of Run 1 indicates it has completed. The Details tab is selected where the the best model, ProphetModel, is indicated along with the run summary.](images/automl-review-run-01.png 'Run details - best model and summary')

2. Select `Models` to see a table view of different iterations and the `Normalized root mean squared error` score for each iteration. Note that the normalized root mean square error measures the error between the predicted value and actual value. In this case, the model with the lowest normalized root mean square error is the best model. Note that Azure Machine Learning Python SDK updates over time and gives you the best performing model at the time you run the experiment. Thus, it is possible that the best model you observe can be different than the one shown below.

    ![The Run Detail screen of Run 1 is displayed with the Models tab selected. A table of algorithms is displayed with the values for Normalized root mean squared error highlighted.](images/automl-review-run-02.png 'Run Details - Models with their associated primary metric values')

3. Return to the details of your experiment run and select the best model **Algorithm name**.

    ![The Run Detail screen of Run 1 is displayed with the Details tab selected. The best model algorithm name is selected.](images/automl-review-run-03.png 'Run details - recommended model and summary')

4. From the `Model` tab, select **View all other metrics** to review the various `Run Metrics` to evaluate the model performance.

    ![The model details page displays run metrics associated with the Run.](images/automl-review-run-04.png 'Model details - Run Metrics')

5. Next, select **Metrics, predicted_true** to review the model performance curve: `Predicted vs True`.

    ![The model run page is shown with the Metrics tab selected. A chart is displayed showing the Predicted vs True curve.](images/automl-review-run-05.png 'Predicted vs True curve')

## Exercise 2: Evaluate model interpretability

Duration: 20 minutes

In this exercise, you will interpret the behavior of one of the models trained in previous exercises.

### Task 1: Create the deep learning model and start a streaming job using a notebook

1. Browse to your Azure Databricks Workspace and navigate to `AI with Databricks and AML \ 5.0 Model Interpretability`. This is the notebook you will step through executing in this exercise.

2. Follow the instructions within the notebook to complete the exercise.

## After the hands-on lab

Duration: 5 minutes

To avoid unexpected charges, it is recommended that you clean up all of your lab resources when you complete the lab.

### Task 1: Clean up lab resources

1. Navigate to the Azure Portal and locate the `ai-in-a-day` Resource Group you created for this lab.

2. Select **Delete resource group** from the command bar.

    ![The Delete resource group button.](images/cleanup-delete-resource-group.png 'Delete resource group button')

3. In the confirmation dialog that appears, enter the name of the resource group and select **Delete**.

4. Wait for the confirmation that the Resource Group has been successfully deleted. If you don't wait, and the delete fails for some reason, you may be left with resources running that were not expected. You can monitor using the Notifications dialog, which is accessible from the Alarm icon.

    ![The Notifications dialog box has a message stating that the resource group is being deleted.](images/cleanup-delete-resource-group-notification-01.png 'Notifications dialog box')

5. When the Notification indicates success, the cleanup is complete.

    ![The Notifications dialog box has a message stating that the resource group has been deleted.](images/cleanup-delete-resource-group-notification-02.png 'Notifications dialog box')

You should follow all steps provided _after_ attending the Hands-on lab.
