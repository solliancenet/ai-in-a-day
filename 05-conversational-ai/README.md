# Lab 5 - Conversational AI with Azure Bot Service and Cognitive Services

With Machine Learning (ML) and Natural Langauge Processing (NLP), Human Machine Interface (HMI) technologies are enjoying an increased adoption year over year. By 2021, [the growth of chatbots in this space is expected to be 25.07%](https://www.technavio.com/report/chatbot-market-industry-analysis). This lab will focus on conversational AI and NLP to help analysts dig into vast amounts of research documents. 

![](media/architecture-diagram.png)

First, we will start with a prepopulate Azure Cognitive Search knowledge base enhanced with Azure Cognitive Skills to test our foundational Bot based on old-fashion keyword lookup, regular expressions. Next, we will extend our conversational Bot's behavior using the Bot Framework Composer and Azure Language Understanding (LUIS). Finally, we will deploy our Bot to Azure Bot Service and enable voice access to our Bot using Cognitive Speech Services and Direct Line Speech channel.

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

Our Bot is now using a **Regular expression recognizer** as its Language Understanding engine. We will extend our Bot with [Azure Language Understanding (LUIS)](https://www.luis.ai/) service. LUIS is a machine learning-based service to build natural language into apps, bots, and IoT devices. LUIS will not only help us build a model but continuously improve as well. 

1. Select **AI-in-a-Day-Bot (1)** under the **Your Project** tree view in the Bot Framework Composer. On the right panel, select **Default Recognizer (2)** instead of **Regular Expression Recognizer** as the Language Understanding engine type. Once set, you will receive an error referring to the missing LUIS keys **(3)**. Select **Fix in bot settings (3)** to navigate to **Project Settings** page.

![AI-in-a-Day-Bot project is selected. Language understanding recognizer type is set to default recognizer. LUIS Key errors are shown and highlighted.](media/bot-composer-luis-error.png)

2. In a Microsoft Edge web browser *(Do not close the Bot Framework Composer)*, navigate to the LUIS portal (https://www.luis.ai/) and login with your credentials. Then select your subscription **(1)** and the authoring resource **(2)**. The LUIS authoring resource allows you to create, manage, train, test, and publish your applications. Select **Done (3)** to proceed.

![Luis portal subscription and authoring resource selection window is shown. Matching resources are selected. The Done button is highlighted.](media/luis-subscription-selection.png)

3. Select the **Settings** button from the top blue bar.

![Settings button is highlighted in the conversation apps page.](media/luis-settings-button.png)

4. Select your subscription **(1)** and the authoring resource **(2)**. Drill down through the arrow button **(3)** to access Authoring resource information. Take not of the **Location (4)** and **Primary Key (5)**.

![Authoring Resource settings page is open. Resource location and primary key are highlighted.](media/luis-settings-key.png)

5. Switch back to the Bot Framework Composer. Type in the **primary key** you noted from the previous step into the **LUIS Authoring key** field (1). Select the **location** you noted from the previous step in the **LUIS region** selection list (2). 

![LUIS settings in the Bot Framework Composer are shown. LUIS Authoring Key and LUIS region are highlighted.](media/bot-composer-luis-settings.png)

6. Switch to the **Design (1)** view. Select **ResearchLookup (2)** trigger. 

![ResearchLookup Trigger is open. Trigger phrases are filled in with LUIS utterances. Condition is set to 0.6 scoring for predictions.](media/research-lookup-luis-trigger.png)

7. Copy and paste the below language understanding code with a list of utterances with a single machine-learning entity type definition called `topic` into the **Trigger phrases** box **(3)**. All topic entities below are labeled with values that LUIS will use as part of the machine learning data set. This is a small set of data. We will have the chance to add more later in the lab, on the LUIS portal.

```plaintext
- Find me publications about {topic=SARS}
- Find me research about {topic=SARS}
- Find me research on {topic=SARS}
- Find me publications on {topic=SARS}
- Get me publications about {topic=SARS}
- Get me research about {topic=SARS}
- Get me research on {topic=SARS}
- Get me publications on {topic=SARS}
- Show me publications about {topic=SARS}
- Show me research about {topic=SARS}
- Show me research on {topic=SARS}
- Show me publications on {topic=SARS}
- Find me publications about {topic=ICU}
- Find me research about {topic=ICU}
- Find me research on {topic=ICU}
- Find me publications on {topic=ICU}
- Get me publications about {topic=ICU}
- Get me research about {topic=ICU}
- Get me research on {topic=ICU}
- Get me publications on {topic=ICU}
- Show me publications about {topic=ICU}
- Show me research about {topic=ICU}
- Show me research on {topic=ICU}
- Show me publications on {topic=ICU}
- Find me publications about {topic=Pathogenesis}
- Find me research about {topic=Pathogenesis}
- Find me research on {topic=Pathogenesis}
- Find me publications on {topic=Pathogenesis}
- Get me publications about {topic=Pathogenesis}
- Get me research about {topic=Pathogenesis}
- Get me research on {topic=Pathogenesis}
- Get me publications on {topic=Pathogenesis}
- Show me publications about {topic=Pathogenesis}
- Show me research about {topic=Pathogenesis}
- Show me research on {topic=Pathogenesis}
- Show me publications on {topic=Pathogenesis}
```

8. Type in `#ResearchLookup.Score>=0.6` into the **Condition (4)** box. This will be our prediction scoring setting for the **ResearchLookup** intent.

![ResearchLookup Trigger is open. Trigger phrases are filled in with LUIS utterances. Condition is set to 0.6 scoring for predictions.](media/research-lookup-luis-trigger.png)

9. Select **OrganizationBasedSearch (1)** trigger. Copy and paste the below language understanding code into the **Trigger phrases** box **(2)**. Type in `#OrganizationBasedSearch.Score>=0.6` into the **Condition (3)** box. 

![OrganizationBasedSearch Trigger is open. Trigger phrases are filled in with LUIS utterances. Condition is set to 0.6 scoring for predictions.](media/organizationbasedresearch-luis-trigger.png)

```plaintext
- Find me publications from {organization=WHO} 
- Show research from {organization=WHO} 
- What research did {organization=WHO} publish?
- Find me publications from {organization=U.S. CDC}  
- Show research from {organization=U.S. CDC} 
- What research did {organization=U.S. CDC} publish?
- Find me publications from {organization=Institute of Cancer Research} 
- Show research from {organization=Institute of Cancer Research} 
- What research did {organization=Institute of Cancer Research} publish?
```

10. Select **AskForMore (1)** trigger. Type in `-More` into the **Trigger phrases** box **(2)**. Feel free to improve the utterances for this Intent by adding more examples.

![AskForMore Trigger is open. Trigger phrase is set to More.](media/askformore-luis-trigger.png)

11. Now that we have set with all our LUIS intents, entities and labels we can start our bot to test locally in the Bot Framework Emulator.

![Start bot button is highlighted.](media/start-bot-luis.png)

12. What about testing the typographical error that failed with our bot's previous version that did not have LUIS's help? Keep in mind that, for the **GetRecentResearch** intent, we still have a single utterance as shown below.

![GetRecentResearch trigger is open. The trigger phrase is highlighted.](media/getrecentresearch-luis-trigger.png)

Here we go, type `What is the latest resarch?` and see what happens.

![A chatbot dialog is shown where the user asks for more research with a question that includes a typographical error. Chatbot responds with a single research finding.](media/getrecentresearch-luis-result.png)

It looks like LUIS was able to understand what we meant without being too picky with typographical errors. 

13. Before we go too far with testing, let's take a look at the LUIS portal to see what happened there. Navigate to [https://www.luis.ai/applications](https://www.luis.ai/applications) in your browser to see a refreshed list of applications. 

![LUIS applications list is shown on the LUIS portal. AI-in-a-Day application is highlighted. ](media/luis-portal-application-list.png)

When we started our local bot through Bot Framework Composer, the composer connected to LUIS Authoring service in Azure to set things up for our bot. Our bot is running locally but connecting to the cloud to talk to the LUIS service. 

14. Select the application to see more details.

15. Once you are in the application page you can see a list of **intents** **(2)**. These are the **triggers** we configured in our bot. The number of **examples** **(3)** listed is the number of utterances we provided as **trigger phrases** in the Bot Framework Composer. 

![A list of intents is presented. Intent names and example counts are highlighted.](media/luis-portal-intents.png)

16. Select the **Entities page (1)** in the portal. Observe the list of entities **(2)** and their type listed as machine learned **(3)**.

![A list of entities is presented. Entity type "machine learned" is highlighted.](media/luis-portal-entity-list.png)

17. Select the **Review endpoint utterances (1)** page in the portal. This is where we can see a list of utterances users wrote and LUIS predicted, but they are outside the original utterance list we provided. In this case, LUIS did a great job predicting that the `What is the latest resarch?` message was targeting the **GetRecentResearch** intent. We can select the approve this prediction by selecting the **Add** button **(4)**. If LUIS had chosen a wrong intent we could change the aligned intent and give our approval to help LUIS learn and improve its predictions. 

![Review endpoint utterances page is open. The message with the typo is highlighted. Aligned intent is shown as GetRecentResearch. Checkmark button is highlighted.](media/luis-portal-review-utterance.png)

18. Now back to our Bot Emulator for more testing. We will test the **OrganizationBasedSearch** Trigger. As a reminder, here is the list of utterances we provided to LUIS.

```plaintext
- Find me publications from {organization=WHO} 
- Show research from {organization=WHO} 
- What research did {organization=WHO} publish?
- Find me publications from {organization=U.S. CDC}  
- Show research from {organization=U.S. CDC} 
- What research did {organization=U.S. CDC} publish?
- Find me publications from {organization=Institute of Cancer Research} 
- Show research from {organization=Institute of Cancer Research} 
- What research did {organization=Institute of Cancer Research} publish?
```

Let's write `any research from Soochow University?` to mix things up. None of the utterances above is a perfect match to what we are going to try.

![A chatbot dialog where the user asks for research from Soochow University. The response has a list of research. A response message has Soochow highlighted.](media/bot-response-luis-soochow.png)

Everything worked fine. It looks like our Bot is in much better shape with the help of LUIS's natural language processing skills. Feel free to test the other intents with phrases like `Show me what's published on SARS` and keep training your model to improve it.

## Task 4 - Deploying Our Bot to Azure Bot Service

It's time to publish our bot to an Azure Bot Service. An Azure Bot Service is not just a location to host a bot. It helps a bot connect to multiple communication channels such as Microsoft Teams, Skype, Slack, Cortana, and Facebook Messenger. In combination with out of box Cognitive Service integrations, Azure Bot Service can accelerator growing your both with new skills. Let's start with baby steps. 

1. Go back to the **Bot Framework Composer** and switch to **Project Settings (1)**. Select **Add new publish profile (2)**.

![Bot Framework Composer Project Settings is open. Add new publish profile link is highlighted.](media/add-new-publish-profile.png)

2. Name your profile `ai-in-a-day` **(1)** and select **Publish bot to Azure Web App (2)** option as the publish target. Select **Next (3)** to move to the next step.

![New profile name is set to ai-in-a-day. Publish Target is set to Azure Web App. The Next button is highlighted.](media/add-new-publish-profile-1.png)

3. We have to go back to the Azure Portal for a moment to grab some key information we will need during the next step. We need the **Resource Group Name** where our Cognitive Services live, and we need the location of the Cognitive Services. Take note of both values to be used in the next step.

![AI-in-a-day Resource Group is open in the Azure Portal. Resource Group Name and Cognitive Service Locations are highlighted.](media/add-new-publish-profile-3.png)

3. During this step, it is crucial to select the subscription option after filling in all the other fields. With that in mind, type in your **Azure Resource Group** name into the **HostName** box **(1)**. Next, please select the location of your Cognitive Services to make sure our bot is deployed to the same location **(2)**. Finally, choose your subscription (3) and select **Next (4)**.

![Deploying resource configuration screen is open. Hostname is set to ai-in-a-day. Location is set to West US. A subscription is selected. The next button is highlighted.](media/add-new-publish-profile-2.png)

4. Make sure you deselect **(1)** all optional resources. We have some of these resources already in place. We will connect those to our deployment profile in the next steps. Select **Done (2)** to complete the process.

![Deployment environment resource selection screen is open. Deselect all command is highlighted. The done button is marked.](media/add-new-publish-profile-deselect-optionals.png)

5. The Bot Framework Composer registered our bot and provisioned the resources **(1)** needed to host our bot in Azure. Now, we have to connect our deployment to our current LUIS Cognitive service. Select **Edit (2)**.

![Provisioning success dialog is presented. Edit button for ai-in-a-day publish profile is highlighted.](media/edit-publish-profile.png)

6. Look at the **Publish Configuration** section **(1)**. We have to type in a couple of keys and endpoints to make sure our bot can talk to our LUIS Cognitive service that is already in our Azure subscription.

![Publish profile edit screen is open. Publish Configuration is highlighted. Save button is pointed.](media/edit-publish-profile-config.png)

Below is a snippet of the **Publish Configuration** where we have to configure all the fields listed. 

```json
    "luis": {
      "authoringKey": "<authoring key>",
      "authoringEndpoint": "",
      "endpointKey": "<endpoint key>",
      "endpoint": "",
      "region": "eastus"
    }
```

7. Let's start with the **authoringKey** and **authoringEndpoint**. Go to the Azure Portal and select the cognitive service that has `Authoring` in its name. This is the LUIS Cognitive service that is used for authoring language content.

![Azure Portal is open. Authoring LUIS Cognitive service is highlighted.](media/luis-authoring-service-selected.png)

8. Select **Keys and Endpoint (1)** section. Copy **Key 1** to the **authoringKey** field replacing `<authoring key>`. Copy **Endpoint** to the **authoringEndpoint** field. Finally, copy **Location** to the **region** field.

![LUIS Authoring service keys and endpoints are shown. Key 1, Endpoint and Location are highlighted.](media/luis-authoring-service-keys.png)

9. The next step is to get the Key and Endpoint for the Prediction Cognitive Service. Go back to the list of resources in the Azure Portal. This time, select the cognitive service called `aiinaday-luis`.

![Azure Portal is open. Prediction LUIS Cognitive service is highlighted.](media/luis-prediction-selected.png)

10. Select **Keys and Endpoint (1)** section. Copy **Key 1** to the **endpointKey** field replacing `<endpoint key>`. Copy **Endpoint** to the **endpoint** field. 

![LUIS Authoring service keys and endpoints are shown. Key 1, Endpoint and Location are highlighted.](media/luis-prediction-keys.png)

Below is an example of how the luis section of your **Publish Configuration** will look like. In your case, all values will be the values you copied from your Azure subscription.

```json
    "luis": {
      "authoringKey": "53070e6f36eb4c7c965c06ebfaf1f6ac",
      "authoringEndpoint": "https://aiinaday-luis-authoring.cognitiveservices.azure.com/",
      "endpointKey": "5c5169e226f94d409eea6db6edad2c10",
      "endpoint": "https://aiinaday-luis.cognitiveservices.azure.com/",
      "region": "westus"
    }
```

11. One final value that has to change in the **Publish Configuration** is the Luis resource name **(1)**. This is the name of the prediction Luis Cognitive Service that we selected in the previous step.

![Publish profile edit screen is open. The luisResource field in the Publish Configuration is highlighted. Save button is pointed.](media/publish-configuration-luis-resource.png)

Once that is done. Select **Save** **(2)**.

12. Switch to the **Publish (1)** section in the Bot Framework Composer. Select our bot **(2)** and select **Publish selected bots (3)** to start the publish process.

![Publish screen is open. Current bot is selected. Publish selected bots button is highlighted.](media/publish-bot-to-azure.png)

13. Select **"Okay"** to approve the publishing.

![Publish approval dialog is shown. Okay button is highlighted.](media/publish-okay.png)

14. Once publishing is complete, go to the Azure Portal and select the **Bot Channels Registration** service. 

![Azure Portal is open. Resources in the resource group are listed. ai-in-a-day bot channels registration is highlighted.](media/bot-channel-registration.png)

15. Switch to the **Test in Web Chat (1)** tab. This is where you can test our bot live in Azure. Feel free to ask questions and observe the results **(2)** we previously tested locally.

![Bot channels registration page is open. Test in web chat tab is selected. A sample chat dialog is highlighted.](media/test-web-chat.png)

## Task 5 - Deploying Our Bot to Azure Bot Service

In this task, we will enable voice access to our Bot through the use of AI. We will use **Azure Cognitive Speech Services** to enable real-time speech to text and text to speech conversion. Thanks to **Bot Channels Registrations** in **Azure Bot Service**, we can use the Direct Line Speech channel to have our Bot drive audio only conversations with client applications.

1. Switch to the **Channels (1)** tab in the **Bot Channels Registration** service. Select **Direct Line Speech (2)**.

![Bot Channels Registration is open. Channels tab is selected. Direct Line Speech is highlighted.](media/bot-channel-registration-dls.png)

2. Select the Cognitive Speech Service named `aiinaday-speech` **(1)** for your **Cognitive service account** and hit **Save (2)**. 

![Configure Direct Line Speech page is open. aiinaday-speech service is higlighted for the cognitive service account.](media/bot-channel-registration-dls-speech.png)

You will now see two channels for your bot.

![Channel registration list is shown. Direct Line Speech and Web Chat are listed.](media/bot-channel-registration-channels.png)

3. Switch to the **Settings (1)** tab. Check **Enable Streaming Endpoint (2)** and select **Save (3)**. 

![Bot Channels Registration Settings is open. Enable streaming endpoint checkbox is selected. Save button is highlighted.](media/bot-channel-registration-streaming-endpoint.png)

4. Go back to your Resource Group and select the `ai-in-a-day` app service.

![Resources in the resource group are listed. ai-in-a-day app service is highlighted.](media/app-service-select.png)

5. Switch to the **Configuration (1)** tab. Select **General settings (2)**. Check **On (3)** for Web sockets and select **Save (4)**. 

![Configuration page for the app service is open. General settings tab is on screen. Web sockets is set to ON. Save button is highlighted.](media/app-service-web-socket.png)

6. In a Microsoft Edge web browser, navigate to the Github Releases page of the Cognitive-Services-Voice-Assistant project here [https://github.com/Azure-Samples/Cognitive-Services-Voice-Assistant/releases](https://github.com/Azure-Samples/Cognitive-Services-Voice-Assistant/releases) and download the released ZIP file **(1)**. Select **Open (2)** when the download is completed.

> **Note:** If you are not able to download and install applications to your computer you can watch a demo of the final result in a [video here](media/DLS-chatbot-demo.mp4).

![The releases page for the Windows Voice Asssistant Client on Github is open. WindowsVoiceAssistantClient ZIP file is selected. Open button on the download dialog is highlighted.](media/windows-voice-assistant-client.png)

7. Navigate into the folder in the ZIP file and find the **VoiceAssistantClient (1)** application file. Double click to start the program. When prompted select **Extract all (2)** to temporary extract the contents of the ZIP file.

![ZIP file is open. VoiceAssistantClient is selected. Extract all command is highlighted.](media/windows-voice-assistant-client-extract.png)

8. Select **Extract**. Once extraction is complete a folder window will pop up.

![ZIP Extract window is open. Extract button is highlighted.](media/windows-voice-assistant-client-extract-2.png)

9. Navigate into the `WindowsVoiceAssistantClient-<date>` folder and find the **VoiceAssistantClient** program. Double click the program to start it.

![Extracted files are shown. VoiceAssistantClient program file is selected.](media/windows-voice-assistant-client-start.png)

10. Once the program opens, it will show you its **Settings** window. If the **Settings** window does not show up, select **Settings gear button (A)** to open the window. We need two values for the settings page: **Subscriptions key** and **Subscription key region (1)**. These are the Azure Cognitive Speech Service's key and region values in our Azure subscription.

![Windows Voice Assistant's Settings page is open. Subscription key and region text boxes are highlighted.](media/windows-voice-assistant-client-config.png)

11. Back in the Azure Portal, select the `aiinaday-speech` service.

![Azure Portal is open. From the resource list aiinaday-speech Cognitive Speech Service is highlighted.](media/speech-service-select.png)

12. Switch to the **Keys and Endpoint (1)** tab. Copy **Key 1 (2)** into the **Subscription Key** textbox in the Settings window of the Windows Voice Assistant Client. Copy **Location (3)** into the **Subscription Key Region** textbox in the Settings window of the Windows Voice Assistant Client. Type in a **Connection profile** name **(3)** and select **Save and Apply Profile (4)**. 

![Speech service keys are shown in the Azure Portal. Windows Voice Assistant's Settings page is open. Windows Voice Assistant's Subscription key and subscription key values are filled in from the Azure Portal. Connection profile is set. Save and Apply Profile button is highlighted.](media/speech-service-keys.png)

13. Select **Reconnect (1)** to connect to the bot. You will hear the greeting message first. At any point feel free to select the **Microphone button (2)** and talk to your bot.

![Windows Voice Assistant Client is open. Reconnect and Microphone buttons are highlighted. A chat dialog is presented.](media/windows-voice-assistant-client-result.png)