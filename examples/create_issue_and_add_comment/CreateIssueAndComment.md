## Create Issue and Add Comment

This use case demonstrates how the Ballerina Jira connector can be utilized to create a new Jira issue and add a comment to it. The example involves a sequence of actions that leverage the Jira API to automate the creation of a task issue and then append a comment to the newly created issue.

## Prerequisites

1. Setup Jira account and API Token
To interact with the Jira API, you need a Jira account and an API token.
Refer to the Atlassian documentation on managing API tokens for detailed instructions on how to generate an API token for your Jira Cloud instance.

2. Configuration
Create a Config.toml file in the example's root directory and provide your Jira account related configurations as follows:

```toml
username = "<Your Jira Account Email>"
password = "<Your Jira API Token>"
domain = "<Your Jira Cloud Domain, e.g., 'your-company'>"
projectKey = "<Your project Id to create Project. 'PD67'>"
```


- username: Your email address used to log in to Jira.

- password: The API token generated from your Atlassian account.

- domain: The subdomain of your Jira Cloud instance (e.g., if your Jira URL is https://your-company.atlassian.net, the domain is your-company).

- projectKey: Your project ID to create the project (e.g., 'PD67').

Ensure that the projectKey is unique and not already in use in your Jira instance, as attempting to create a project with an existing key will result in an error. Also, ensure the leadAccountId is correctly retrieved for the user.

Run the example
Execute the following command to run the example:

```bash
bal run
```

