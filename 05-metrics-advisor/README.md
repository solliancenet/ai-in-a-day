# Lab 5 - Data monitoring and anomaly detection using Metrics Advisor in Azure Cognitive Services

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

![Architecture for Lab 5](./../media/Architecture-5.png)

The high-level steps covered in the lab are:

- Explore dashboard of COVID-19 data
- Explore the lab scenario
- Onboard your time series data in the Metrics Advisor
- Explore anomalies detected in your data
- Perform root cause analysis
- Explore anomalies with hard thresholds (optional)

## Task 3 - Configure the "COVID cases by age group" Metrics Advisor data feed

1. Open the [Azure Portal](https://portal.azure.com) and sign-in with your lab credentials.

2. In the list of your recent resources, locate the the storage account named `aiinadaystorageXXXXXX`.

    ![Locate storage account in Azure Portal](./media/datastore-01.png)

3. Select `Access keys` from the left side menu, and then select `Show keys`. Save the storage account name, the `key1 Key` value, and the `key1 - Connection string` value for later use.

    ![Storage account name and key](./media/datastore-03.png)

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
    - **Ingest data since (UTC)**: `2021-01-01`
    - **Connection string**: provide the connection string from the blob storage access keys page. (`key1 - Connection string` copied on step 3)
    - **Container**: `jsonmetrics`
    - **Blob template**: `%Y-%m-%d.json` (since the daily json files are provided in with naming format)
    - **JSON format version**: `v2` (since we'll be using the age group dimension in our data schema)

    ![Data feed source properties](./media/adddatafeed.png)

9. Select the **Verify and get schema button** to validate the configured connection.  If there is an error at this step, check that your connection string and blob template are correct and your Metrics Advisor instance is able to connect to the data source.

10. Once the data schema is loaded and shown like below, configure the appropriate fields as Dimension, Measure or Timestamp.

    ![Schema configuration](./media/schemconfig.png)

11. Scroll down towards the bottom of the page. For **Automatic roll-up** settings, select the **I need the service to roll-up my data** (1) option, select the link **Set roll-up columns** and include both dimensions (3).

    ![Automatic rollup settings](./media/automaticrollup.png)

12. In the **Advanced settings** section, inside **Ingestion options**, set **Stop retrying after** to **0** hours to stop the ingestion process after the first run. 
    
    ![Advanced settings](./media/advancedsettings.png)

13. In the **Misc** section, choose the option to **Fill previous** for anomaly detection model.

    ![Misc settings](./media/fillprevious.png)

14. Provide the **Data feed name**: `covid-ages` and select **Submit** to confirm and submit the data feed.

    ![Submit schema configuration](./media/submitdatafeed.png)

15. Wait for the ingestion progress dialog and select the **Details** link in order to observe the ingestion log by timestamp. Wait until the ingestion completes with success for all ingested json files.

    ![Check the ingestion progress](./media/ingestionprogress.png)


## Task 4 - Explore anomalies detected in data

After the data feed is added, Metrics Advisor will attempt to ingest metric data from the specified start date. It will take some time for data to be fully ingested, and you can view the ingestion status by clicking Ingestion progress at the top of the data feed page. If data is ingested, Metrics Advisor will apply detection, and continue to monitor the source for new data.

When detection is applied, you can select one of the metrics listed in data feed to find the Metric detail page to:

- View visualizations of all time series slices under this metric
- Update detecting configuration to meet expected results
- Set up notification for detected anomalies


1. Select the **Visit data-feed: covid-ages** button to navigate to the data feed overview page.

    ![Check the ingestion progress](./media/ingestionprogress.png)

2.  In the data feed page, select the `count` metric under the **Metrics** section.

    ![Go to the count metric details page](./media/browsemetricdata.png)

3.  To modify the inspected time window, change the start and end time of the interval from the calendar above the graphic representations. Set the interval to start from `2021-01-01`.

    ![Change monitoring time window](./media/changetimewindow.png)

4.  Make sure you see the ingestion process completed on recent historical data **(1)** as illustrated in the picture bellow. When all data is ingested, in the left configuration section, under the **Metric-level configuration** **(2)** change the default metric-level configuration to use Smart detection and set the sensitivity level to 81 and use this configuration:
    - Value **Out of boundary** is anomaly 
    - Do not  report anomaly until **10%** of latest **1** points are detected as anomalies.

    ![Metric-level configuration](./media/metric-level-configuration-smart.png)

>Note
>
> - To view the diagnostic insights, click on the red dots **(3)** on time series visualizations, which represent detected anomalies and select the link **To incident hub**. 
>
> - Spend a few minutes to change some parameters inside the **Metric-level configuration** section and observe the change of reported anomalies (red points) on the series data representation.

5. In the metrics browser page, select the **Incidents** tab and filter the list to see the incidents related to number of cases that required hospitalization hosp_ym = `Yes`. Select the anomaly reported for SUM of hospitalized cases.
    ![Filter incidents by hospitalization](./media/hosp_yes.png)

## Task 5 - Perform root cause analysis

1.  In the incidents hub, notice the **Root cause** section where you should find reported the main contributors for the detected anomaly, age groups that contributed to the sum of cases reported as anomaly. Also, in the **Diagnostic** tree, hover on each age group node to investigate its contribution to the incident.
    ![Incident Hub diagnostics](./media/root_cause_incidents_hub.png)

2.  In the **Diagnostics** (1) section, navigate to **Metrics drill-down** (2) and notice the current point Value (number of cases) and the **Diff**  from the identified **Baseline** (3). Choose the **age_group** dimension to drill-down by it and check the same **Delta** percent and **Diff** value from the baseline for the anomalies detected in the current point.
    ![Metrics drill down](./media/metrics-drill-down.png)


## Task 6 - Explore anomalies with hard thresholds (optional)

As an optional exercise, you can create a different detection configuration, based on hard thresholds rather than smart detection.

To do this, go back to the metric detection configuration screen and try a new configuration as follows **(1)**:

- **Hard threshold**
- Value **Out of range** Min: **1000** and Max: **9000** is an anomaly
- Do not report anomaly until 100% of latest **10** points are detected as anomalies

We should have marked as anomalies the points in time where number of cases is bellow or above a fixed threshold for 10 continous points in time.(Notice the yellow dots **(2)** before the reported anomalies and how the threashold is delimited by the red horizontal lines **(3)**).

![Hard threshold](./media/hardthreshold.png)
