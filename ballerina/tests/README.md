# Running Tests

## Prerequisites
You need API token and your organization ID (ex: https://example.atlassian.com) from [atlassian account](https://home.atlassian.com/).

To do this, refer to [Ballerina Jira Connector](../README.md).


# Running Tests

There are two test environments for running the Jiraa connector tests. The default test environment is the mock server for Jira REST API. The other test environment is the actual Jira REST API. 

You can run the tests in either of these environments and each has its own compatible set of tests.

 Test Groups | Environment                                       
-------------|---------------------------------------------------
 mock_tests  | Mock server for Jira REST API (Defualt Environment) 
 live_tests  | Jira REST API                                       

## Running Tests in the Mock Server

To execute the tests on the mock server, ensure that the `IS_LIVE_SERVER` environment variable is either set to `false` or unset before initiating the tests. 

This environment variable can be configured within the `Config.toml` file located in the tests directory or specified as an environmental variable.

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and the following content:

```toml
isLiveServer = false
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:
If you are using linux or mac, you can use following method:
```bash
   export IS_LIVE_SERVER=false
```
If you are using Windows you can use following method:
```bash
   setx IS_LIVE_SERVER false
```
Then, run the following command to run the tests:

```bash
   ./gradlew clean test
```

## Running Tests Against Jira Live API

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and add your authentication credentials a

```toml
   isLiveServer = true
   userApiToken = "<your-jira-access-token>"
   userId = "<your-jira-user-email>"
   jiraDomain = "<first-part-of-your-jira-organization-id (example in example.atlassian.com)>"
```

#### Using Environment Variables

Alternatively, you can set your authentication credentials as environment variables:
If you are using linux or mac, you can use following method:
```bash
   export IS_LIVE_SERVER=true
   export JIRA_TOKEN ="<your-jira-access-token>"
   export JIRA_USER_NAME ="<your-jira-user-email>"
   export JIRA_DOMAIN ="<your-jira-organization-id>"
```

If you are using Windows you can use following method:
```bash
   setx IS_LIVE_SERVER true
   setx JIRA_TOKEN <your-jira-access-token>
   setx JIRA_USER_NAME  <your-jira-user-email>
   setx JIRA_DOMAIN  <your-jira-organization-id>
```
Then, run the following command to run the tests:

```bash
   ./gradlew clean test 
```