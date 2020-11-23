# Microsoft **AI in a Day** Labs

## Background story

Trey Research is looking to provide the next generation experience for connected car manufacturers by enabling them to utilize AI to decide when to pro-actively reach out to the customer through alerts delivered directly to the car's in-dash information and entertainment head unit. For their proof-of-concept (PoC), they would like to focus on several maintenance related scenarios.

Trey Research recently instituted new regulations defining what parts are compliant or out of compliance. Rather than rely on their technicians to assess compliance, they would like to automatically assess the compliance based on component notes already entered by authorized technicians. Specifically, they are looking to leverage Deep Learning technologies with Natural Language Processing techniques to scan through vehicle specification documents to find compliance issues with new regulations. Then each car is evaluated for out compliance components.

PDF documents capture the largest part of the car parts compliance information. One of the challenges Trey Research faces is the time spent manually processing those PDF forms. They are looking to improve processing efficiency by deploying state of the art technologies to process and index the documents.

Trey Research would like to predict the likelihood of battery failure based on the time series-based telemetry data that the car provides. The data contains details about how the battery performs when the vehicle is started, how it is charging while running, and how well it is holding its charge, among other factors. If they detect a battery failure is imminent within the next 30 days, they would like to send an alert.

Several faulty sensors sent incorrect readings in recent months that triggered customers' notifications and incorrect schedulings for battery replacements. The errors caused negative reviews from those customers, and Trey Research is looking for ways to avoid such cases in the future.

To improve the quality of its customers' customer service, Trey Research provides support for detailed tracking of past customer visits. It uses historical data to predict the likelihood of customers returning to repairs soon. They are looking to provide enhanced support for resource planning and scheduling while also prioritizing customers based on their track record. They are concerned about model bias, and they are actively looking for ways to detect it at least. 

Finally, Trey Research wants to provide support for a better customer experience by allowing customers to schedule their visits using a modern, multifunctional conversational platform.

## The end-to-end architecture

![](./media/Overall%20Architecture.png)

## Labs

Each individual lab in this repo addresses a subset of Trey Reasearch's challenges.

Name | Description | Useful links
--- | --- | ---
Lab 1 - [Azure Machine Learning Model Training](01-aml-model-training/README.md) | The lab covers Automated ML, model explainabity, and model fairness.
Lab 2 - [Azure Machine Learning Operationalization](02-aml-operationalization/README.md) | The lab covers model deployment, batch and real-time scoring, and model monitoring.
Lab 3 - [Machine Learning in Azure Databricks](03-ml-in-databricks/README.md) | The lab covers Spark ML and Azure Machine Learning integration (Azure ML SDK and MLFlow integration).
Lab 4 - [Knowledge Mining with Azure Cognitive Search and Form Recognition](04-knowledge-mining/README.md) | This lab covers Azure Cognitive Search (index, knowledge store, custom skills) and Forms Recognizer. | https://github.com/Azure-Samples/azure-search-knowledge-mining
Lab 5 - [Conversational AI with Azure Bot Service](05-conversational-ai/README.md) | The lab covers the Azure Bot Service (Bot Framework Compose and LUIS).
Lab 6 - [Anomaly Detection and Metrics Advisor with Azure Cognitive Services](06-decision-and-form-recognizer/README.md) | The lab covers the Anomaly Detector and Metrics Advisor services from Azure Cognitive Services.


