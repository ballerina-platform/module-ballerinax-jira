
## Overview

[Jira](https://www.atlassian.com/software/jira)  is a widely-used issue and project tracking software by Atlassian. It provides a REST API that allows applications to connect with Jira to create, update, and delete various resources, enabling efficient project and task management.

The `ballerinax/jira` package offers APIs to interact with the [Jira REST API](https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro), providing access to various endpoints for managing issues, filters, projects, and other resources.

## Setup guide

To use the Jira connector, you must have a Jira Cloud account with API access. If you do not have one, you can sign up for a Jira account on [Atlassian’s website](https://developer.atlassian.com/cloud/jira/platform/).

### Step 1: Create an API Token
1. Log in to [Atlassian Account](https://developer.atlassian.com/cloud/jira/platform/)

2. Click on the profile icon to get into developer console

 <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/atlassian-developer-console#1.png alt="Atlassian developer console" style="width: 70%;">

3. In the new window, click on the profile again and go to `Manage Account`.

4. Click and go to security tab and scroll down to the bottom to generate API token by clicking 'Create and Manage API token'

 <img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/create-API-Token#2.png alt="Create API Token" style="width: 70%;">

5. Give a name to the API token and copy and save it in a secret place.

<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/generate-API-Token#3.png alt="Generate API Token" style="width: 70%;">

### Step 2: Integrate JIRA for your account
1. Click on the grid shaped icon in the right corner (Before Atlassian Account logo). Click on `Explore Products`.

<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/integrate-Jira#4.png alt="Integrate Jira" style="width: 70%;">

2. Click on the try cloud button under Jira.

<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/try-jira-cloud#5.png alt="Try jira" style="width: 70%;">

3.Click `Get Jira for free`.

<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/get-Jira-Free#6.png alt="Get jira for free" style="width: 70%;">

4. Enter your email that you used previously to log into the Atlassian account.

<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/email-for-jira#7.png alt="Enter email for jira account" style="width: 70%;">

5. Make sure to copy the Domain URL provided for you (Your site URL).

<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/domain-URL-Jira#8.png alt="Create API Token" style="width: 70%;">

You have successfully integrated Jira with your Atlassian account. Now you can access the services through the API

## Quickstart

To use the `Jira` connector in your Ballerina application, update the `.bal` file as follows:

### step 1: Import the module

Import the `jira` module.

```ballerina
import ballerinax/jira;
```
### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

```bash
baseUrl = "<Jira Cloud Domain URL>"
username = "<Your Atlassian Account Email>"
apiToken = "<Your Jira API Token>"
```

2. Create a `jira:ConnectionConfig` with the obtained access token and initialize the connector with it.

```ballerina
configurable string baseUrl = ?;
configurable string username = ?;
configurable string apiToken = ?;

jira:ConnectionConfig config = {
    auth: <http:CredentialsConfig>
    {
        username: username,
        password: apiToken
    }
};
final jira:Client jira = check new (config, baseUrl);
```
### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### create a role

```ballerina
public function main() returns error? {
    jira:ProjectRole role = check jiraClient->/rest/api/3/role.post(
        payload = {
            name: roleName,
            description: roleDescription
        }
    );
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `Jira` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/module-ballerinax-jira/tree/main/examples/), covering the following use cases:

1. [Jira-project-and-issue-management](https://github.com/ballerina-platform/module-ballerinax-jira/blob/main/examples/jira-project-and-issue-management/main.bal)