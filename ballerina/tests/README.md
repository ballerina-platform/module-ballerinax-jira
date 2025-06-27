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
## Running Tests Against Jira Live API

#### Using a Config.toml File

Create a `Config.toml` file in the tests directory and add your authentication credentials a

```toml
isLiveServer = true;
username = "<Your Jira Account Email>"
password = "<Your Jira API Token>"
domain = "<Your Jira Cloud Domain, e.g., 'your-company'>"
```
