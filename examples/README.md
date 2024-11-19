# Examples

The `ballerinax/jira` connector provides practical examples illustrating usage in various scenarios.

1. [Jira-project-and-issue-management](https://github.com/ballerina-platform/module-ballerinax-jira/blob/main/examples/JiraProjectManagement/main.bal)

## Prerequisites
1. Set Up Jira API Access

Obtain an Atlassian API token from your Jira account by following [Atlassian's API token generation guide](https://central.ballerina.io/ballerinax/jira/latest#setup-guide).
Note down your Jira domain (e.g., your-domain.atlassian.net), API token and username(email).

2. Create a `Config.toml` file in the example’s root directory and add your Jira API credentials as shown below:

```bash
SERVICE_URL = "<Jira Cloud Domain URL>"
JIRA_USERNAME = "<Your Atlassian Account Email>"
JIRA_TOKEN = "<Your Jira API Token>"
```

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
