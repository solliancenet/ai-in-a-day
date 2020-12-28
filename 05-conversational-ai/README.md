# Lab 5 - Conversational AI with Azure Bot Service and Cognitive Services

With Machine Learning (ML) and Natural Langauge Processing (NLP), Human Machine Interface (HMI) technologies are enjoying an increased adoption year over year. By 2021, [the growth of chatbots in this space is expected to be 25.07%](https://www.technavio.com/report/chatbot-market-industry-analysis). This lab will focus on conversational AI and NLP to help analysts dig into vast amounts of research documents. 

First, we will start with a prepopulate Azure Cognitive Search knowledge base enhanced with Azure Cognitive Services to test our foundational Bot based on old-fashion keyword lookup, regular expressions. Next, we will extend our conversational Bot's behavior using the Bot Framework Composer and Azure Language Understanding (LUIS). Finally, we will deploy our Bot to Azure Bot Service.

## Task 1 - Setting Azure Cognitive Search for a Chatbot

1. Download the starter [Bot project ZIP file](AI-in-a-Day-Bot.zip) to your **Documents** folder. Extract the contents of the ZIP file.

![Zip file saved in Documents. Operating system context menu is open. Extracl all is highlighted.](media/extract-zip-file.png)

2. Launch the **Bot Framework Composer (1)** from its shortcut on Desktop. Select **Open (2)** to load our starter project.

![Bot Framework is open. Open menu command is highlighted.](media/bot-composer-project-open.png)

3. Navigate to your **Documents** folder **(1)**. Select the **AI-in-a-Day-Bot** by double clicking **(2)** on it.

![Location is set to users documents folder. AI-in-a-Day-Bot project is highlighted.](media/bot-composer-project-open-2.png)

4. In a Microsoft Edge web browser *(Do not close the Bot Framework Composer)*, navigate to the Azure portal (https://portal.azure.com) and login with your credentials. Then select **Resource groups**.

![Open Azure resource group](media/azure-open-resource-groups.png)

5. Select the **AI-in-a-Day** resource group.

6. Select the Azure Cognitive Search service.

![Azure Cognitive Search service is highlighted from the list of services in the AI-in-a-Day Resource Group](media/select-azure-cognitive-search.png)

7. Select **Indexes (1)** and observe the number of documents indexed in the **cognitive-index (2)**.

![Indexes tab is open and cognitive-index is highlighted.](media/azure-cognitive-search-index.png)

8. Select **Search Explorer** to navigate to a web-based search experience where you can discover the data in the index.

![Cognitive Search service is open. Search Explorer command is highlighted.](media/azure-cognitive-search-explorer.png)

9. Select **Search (1)** to access a sample set of documents from the index. Scroll down and observe the data stored in the index. The values for the fields `people`, `organizations`, `locations`, and `keyphrases`, are created through the use of Azure Cognitive Services as part of the data enrichment process during data indexing.

![Showing a sample set of RAW documents from Azure Cognitive Search. People, organizations, locations and keyphrases fields are highlighted.](media/azure-cognitive-search-explorer-result.png)

10. Close the **Search Explorer**. Navigate to the **Keys (1)** panel. Copy the primary admin key by selecting the copy command **(2)**.

![Azure Cognitive Search service page is open. Keys tab is shown. Primary admin key copy command is highlighted.](media/azure-cognitive-search-key.png)

11. Now it's time to change the access keys used in our starter Bot to use our Azure Cognitive Search service. Go back to the Bot Framework Composer. Select **Greeting** trigger **(1)**. From the design, surface select the first **Set a property** activity **(2)**. You will see a **Value** field **(3)** on the right panel. We have to change the value with the primary admin key we have copied from the Azure Portal. 

![Bot Framework Composer is on screen. Greeting trigger is selected. Set a property activity is selected. The value field on the right panel is highlighted.](media/starter-bot-key-change.png)

## Task 2 - Running AI-in-a-Day Conversational Bot for the First Time

1. It is time to start out bot in the local Bot Framework Emulator. Select **Start bot** from the top of the window in the Bot Framework Composer.

![Start bot command in the Bot Framework Composer is highlighted.](media/start-starter-bot.png)

2. Once the local bot runtime is ready, a pop-up will appear. Select **Test in Emulator** to start the local Bot Framework Emulator.

![Local but runtime is ready. Test in Emulator command is highlighted.](media/bot-composer-test-in-emulator.png)

3. Write `What is the latest research?` and observe **(1)** how the bot will respond. You can see the API communication between the emulator and the bot in the list of logs **(2)**.

![A dialog between the bot and the user showing latest COVID research is highlighted. Logs about API requests are shown.](media/bot-response-regex-getrecentresearch.png)

4. Write `Find me publications about SARS` and observe how the bot will respond. 

![A dialog where the user asks for more COVID publications related to SARS and five research results is presented.](media/bot-response-regex-researchlookup.png)

5. Write `More` and observe how the bot will respond. 

![A dialog where the user asks for more COVID publications related to SARS and one more research result is presented.](media/bot-response-regex-askformore.png)

6. Write `Find me publications from WHO` and observe how the bot will respond. 

![A dialog where the user asks for more COVID publications published by WHO and five  research result is presented.](media/bot-response-regex-organizationbasedresearch.png)

7. Now, let's go back to the **Bot Framework Composer** and see how the bot understands our commands. Select **GetRecentResearch** trigger **(1)** and look at the trigger phrase **(2)**. Our current trigger phrase is set to exactly match what we previously wrote in chat in the Bot Framework Emulator.

![GetRecentResearch trigger is selected. Trigger phrase is highlighted.](media/getrecentresearch-trigger-phrase.png)

8. Switch back to the emulator and write, `What is the latest resarch?`. You will see that our bot can't understand the message anymore. So far, our bot has used **Regular Expression Recognizer** as its Language Understanding engine. The current setup for the **GetRecentResearch** trigger matches only an exact text to detect user intent. A simple typographical error results in a failure.

![A dialog shows the user asking latest research with a typo in the text. Bot responds with a sorry message.](media/bot-regex-response-latestresearch-fail.png)

9. Switch back to the **Bot Framework Composer** and select **ResearchLookup (1)**. Remember, previously, we asked the bot `Find me publications about SARS` to get the latest COVID research related to SARS. You can find the regular expression used to detect the user's intent in the **Trigger Phrases (2)** section. If the user writes anything else, maybe a typographical error, the bot will fail to understand its user's intent. 

![ResearchLookup trigger is selected. Trigger phrase regular expression is shown to detect a single pattern.](media/research-lookup-regex-trigger.png)

10. Feel free to look into the other triggers in the starter project and ask different questions to our bot to test how the different regular expressions set for the current triggers work.

## Task 3 - Extending Our Conversational Bot Using LUIS

## Task 4 - Deploying Our Bot to Azure Bot Service










