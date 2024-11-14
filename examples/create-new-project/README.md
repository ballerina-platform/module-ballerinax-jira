#Jira Project and Issue Management Example

This example demonstrates how to use the Jira API to automate project and issue management. The example workflow involves creating a new project, creatig roles specific to the project and creating issues within the project. It showcases how to streamline task management using Jira’s REST API (V3).

##Prerequisites
1. Set Up Jira API Access

Obtain an Atlassian API token from your Jira account by following [Atlassian's API token generation guide.](https://central.ballerina.io/ballerinax/jira/latest#setup-guide)
Note down your Jira domain (e.g., your-domain.atlassian.net), API token and username(email)

2. Create a `Config.toml` file in the example’s root directory and add your Jira API credentials as shown below:

```bash
SERVICE_URL = "<Jira Cloud Domain URL>"
JIRA_USERNAME = "<Your Atlassian Account Email>"
JIRA_TOKEN = "<Your Jira API Token>"
```
##Run the Example
To execute the workflow, run the following command in your terminal:

```bash
bal run
```