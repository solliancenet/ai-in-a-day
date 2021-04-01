# Setup the Lab 01 AI-in-a-Day Workspace

## Task 1 - Create resources

1. If it does not already exist, create a new resource group with the `AI-in-a-Day` prefix.
2. In the resource group, create a new [**Azure Machine Learning** service](https://azure.microsoft.com/en-us/services/machine-learning/).
3. Once the new **Azure Machine Learning** service has been created, open it and click the **Launch studio** button to open the Azure Machine Learning studio. Alternatively, you can go directly to [ml.azure.com](https://ml.azure.com) and open your service from there.
4. In Azure Machine Learning studio, go to the **Compute** blade and create a new **Compute instance** which you will use to run the provided notebooks. Choose a `Standard_DS3_v2` CPU machine.

## Task 2 - copy notebooks to the AML workspace

1. In the Jupyter notebook environment, navigate to the folder associated with your lab user.

2. If the folder does not contain any notebooks, download the following items to your local machine:

[1. Data Preparation.ipynb](https://solliancepublicdata.blob.core.windows.net/ai-in-a-day/lab-01/1.%20Data%20Preparation.ipynb)

[3. Document Classification.ipynb](https://solliancepublicdata.blob.core.windows.net/ai-in-a-day/lab-01/3.%20Document%20Classification.ipynb)

[covid_embeddings_model_500_docs.w2v](https://solliancepublicdata.blob.core.windows.net/ai-in-a-day/lab-01/covid_embeddings_model_500_docs.w2v)

[Setup.ipynb](https://solliancepublicdata.blob.core.windows.net/ai-in-a-day/lab-01/Setup.ipynb)

Upload each file by selecting the `Upload` button from the top right corner of the screen, and then selecting the blue `Upload` button to confirm. 

## Task 3 - Run the setup notebook

1. Run the Setup.ipynb notebook in the Jupyter notebook environment. This notebook will create the `aml_compute_cpu compute` cluster, registers the necessary datasets: `COVID19Articles_Test` and `COVID19Articles_Train` and submits the `COVID19_Classification` experiment without setting the metric exit criteria.
