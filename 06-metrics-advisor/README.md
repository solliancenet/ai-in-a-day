# Lab 6 - Anomaly Detection and Form Recognition with Azure Cognitive Services

This lab covers the Metrics Advisor service from Azure Cognitive Services.

## Task 1 - Explore dashboard of COVID-19 data

Understanding the source datasets is very important in AI and ML. To help you expedite the process, we have created a Power BI dashboard you can use to explore them at the begining of each lab.

![Azure AI in a Day datasets](../media/data-overview-01-01.png)

To get more details about the source datasets, check out the [Data Overview](../data-overview.md) section.

To explore the dashboard of COVID-19 data, open the `Azure-AI-in-a-Day-Data-Overview.pbix` file located on the desktop of the virtual machine provided with your environment.

## Task 2 - Explore lab scenario

Advanced indexing and search work well as long as the corpus of documents contains as little noise as possible. By noise, we identify both issues within documents and whole documents that are not related (or are not close enough, for that matter) to the problem of COVID-19 and its associated domains. In the early stages of document collection, the focus is on the sheer volume (collect as many documents as possible) rather than on quality. However, the system should dismiss documents that are not related to the topics of interest as early as possible.

Using Anomaly Detection and Metrics Advisor, we will demonstrate how to improve the quality of the research document collection process by identifying as early as possible documents that are not related to the problem of COVID-19 and its associated domains.

The following diagram highlights the portion of the general architecture covered by this lab.

![Architecture for Lab 6](./../media/Architecture-6.png)

The high-level steps covered in the lab are:

- Explore dashboard of COVID-19 data
- Explore the lab scenario
- Identify the concept of anomaly detection in a stream of documents
- Explore the modeling of documents in the content of the anomaly detection problem
- Train the anomaly detection problem in an Azure Machine Learning notebook
- Identify anomalies in a stream of new documents

