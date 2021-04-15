# Lab 6 - Data monitoring and anomaly detection using Metrics Advisor in Azure Cognitive Services

This lab covers the Metrics Advisor service features from Azure Cognitive Services.

## Task 1 - Explore dashboard of COVID-19 data

Understanding the source datasets is very important in AI and ML. To help you expedite the process, we have created a Power BI dashboard you can use to explore them at the begining of each lab.

![Azure AI in a Day datasets](../media/data-overview-01-01.png)

To get more details about the source datasets, check out the [Data Overview](../data-overview.md) section.

To explore the dashboard of COVID-19 data, open the `Azure-AI-in-a-Day-Data-Overview.pbix` file located on the desktop of the virtual machine provided with your environment.

## Task 2 - Explore lab scenario

Besides collecting data about COVID-19 cases, it is also essential to ensure the accuracy of the reporting. Accuracy check is where continuous monitoring of incoming data feeds doubled by automatic detection of anomalies plays a critical role. Data is valid for analysis as long as it is reliable and contains the minimum possible number of errors. With distributed data sources and numerous reporting entities, automatic anomaly detection is the best choice to minimize that number.

Using Cognitive Services Metrics Advisor, we will demonstrate how to improve the case surveillance data quality by identifying as early as possible anomalies in the number of daily reported cases.

The following diagram highlights the portion of the general architecture covered by this lab.

![Architecture for Lab 6](./../media/Architecture-6.png)

The high-level steps covered in the lab are:

- Explore dashboard of COVID-19 data
- Explore the lab scenario
- Prepare the cases surveillance time series data to feed into the Metrics Advisor
- Onboard your time series data in the Metrics Advisor
- Tune the anomaly detection configuration

## Task 3 - Configure the COVID cases by age group Metrics Advisor data feed

1. Open the [Azure Portal](https://portal.azure.com) and sign-in with your lab credentials.

2. In the list of your recent resources, locate the the storage account named `aiinadaystorageXXXXXX`.

    ![Locate storage account in Azure Portal](../06-metrics-advisor/media/datastore-01.png)

3. Select `Access keys` from the left side menu, and then select `Show keys`. Save the storage account name, the `key1 Key` value, and the `key1 - Connection string` value for later use.

    ![Storage account name and key](../06-metrics-advisor/media/datastore-03.png)

4. Back to the Home page in Azure Portal, in the list of your recent resources, locate the Azure Metrics Advisor workspace and select it. If you are prompted to sign-in again, use the same lab Azure credentials you used at the previous step.
![Open Azure Metrics Advisor](./media/openmetricsadvisor.png)

5. On the Metrics Advisor Quick start page, select the `Go to workspace` link in the first section to start working with the web-based [Metrics Advisor workspace](https://metricsadvisor.azurewebsites.net/).

    ![Start the web-based workspace](./media/startmetricsadvisor.png)

6. On the Metrics Advisor welcome page, select your Directory, subscription and workspace information and select **Get started**. You are now prepared to create your first Data feed.

    ![Connect to Metrics Advisor workspace](./media/metrics-advisor-connect.png)

7. With the Metrics Advisor workspace opened, select the **Add datafeed** option from the left navigation menu.

8. Add the data feed by connecting to your time-series data source. Start by selecting the following parameters:

    - **Source type**: `Azure Blob Storage (JSON)`
    - **Granularity**: `Daily`
    - **Ingest data since (UTC)**: `2020-01-01`
    - **Connection string**: provide the connection string from the blob storage access keys page.
  
        ![Get the blob storage connection string](./media/blobstorageconnectionstring.png)

    - **Container**: `jsonmetrics`
    - **Blob template**: `%Y-%m-%d.json` (since the daily json files are provided in with naming format)
    - **JSON format version**: `v2` (since we'll be using the age group dimension in our data schema)

    ![Data feed source properties](./media/adddatafeed.png)

9. Select the **Verify and get schema button** to validate the configured connection.  If there is an error at this step, check that your connection string and blob template are correct and your Metrics Advisor instance is able to connect to the data source.

10. Once the data schema is loaded and shown like below, configure the appropriate fields as Dimension, Measure or Timestamp.

    ![Schema configuration](./media/schemconfig.png)

11.  Scroll down towards the bottom of the page. For **Automatic roll-up** settings, select the `I do not need to include the roll-up analysis for my data` option.

12. Provide the **Data feed name**: `covid-ages`.

13. Select **Submit** to confirm and submit the data feed.

    ![Submit schema configuration](./media/submitdatafeed.png)

14. Wait for the ingestion progress dialog and select the **Details** link in order to observe the ingestion log by timestamp.

    ![Check the ingestion progress](./media/ingestionprogress.png)

15. Select the **Visit data-feed: covid-ages** button to navigate to the data feed overview page.

16. In the data feed page, select the `count` metric under the **Metrics** section.

    ![Go to the count metric details page](./media/browsemetricdata.png)

17. To modify the inspected time window, change the start and end time of the interval from the calendar above the graphic representations.

    ![Change monitoring time window](./media/changetimewindow.png)

18. In the left configuration section, under the **Metric-level configuration** change the default metric-level configuration to mark anomalies when the count value changes to 50% in or out of the range of the previous point count (in our scenario compared with the previous day).

    ![Metric-level configuration](./media/metric-level-configuration.png)

    Spend a few minutes to change some parameters inside the **Metric-level configuration** section and observe the change of reported anomalies (red points) on the series data representation.

