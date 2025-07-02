# Ballerina Jira connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-jira/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-jira/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-jira.svg)](https://github.com/ballerina-platform/module-ballerinax-jira/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/jira.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%jira)

## Overview

[Jira](https://www.atlassian.com/software/jira) is a powerful project management and issue tracking platform developed by Atlassian, widely used for agile software development, bug tracking, and workflow management.

The `ballerinax/jira` package provides APIs to connect and interact with Jira’s REST API endpoints, enabling seamless integration for operations such as managing issues, projects, users, and workflows. The latest version corresponds to the [REST API version 3 (Cloud)](https://developer.atlassian.com/cloud/jira/platform/rest/v3/intro/), which builds upon v2 with additional support such as Atlassian Document Format (ADF) in fields like comments and descriptions.

## Setup guide

To use the Jira connector, you must have access to the Atlassian API through your Atlassian account. To access premium features, a Premium subscription is required. If you do not have an account, you can sign up for one [here](https://id.atlassian.com/login).

### Step 1: Create an Atlassian account

1. Sign up for an account or log in to your Atlassian account

![Jira login screen](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/login_screen.png)

2. You will be redirected after a successful login.

![Jira redirect screen](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/redirect_login.png)

### Step 2: Create API token

1. Click on **account settings**

![Jira account settings path](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/path_account_settings.png)

2. Click on **security** tab

![Jira account settings](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/account_settings.png)

3. Click on **Create and manage API tokens**

![Jira Token](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/click_on_token.png)

4. Create API token

![Create Token](https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/create_token.png)

5. Store the access token securely for use in your application.

## Quickstart

To use the `Jira` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `jira` module.

```ballerina
import ballerinax/jira;
```
### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and, configure the obtained credentials in the above steps as follows:

```toml
username = "<your email>"
password = "<Access Token>"
```
2. Create a jira:ConnectionConfig with the obtained access token and initialize the connector with it.

```ballerina
configurable string username = ?;
configurable string password = ?;

jira:ConnectionConfig config = {
    auth: {
        username,
        password
    }
};

final jira:Client jiraClient = check new(config,<"your-organization-id.atlassian.net/rest>">);
```

### Step 3: Invoke the connector operation

#### Get the user

```ballerina
public function main() returns error? {
    jira:User user = check jiraClient->/api/'3/myself;
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```


## Examples

The `Jira` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-jira/tree/main/examples/), covering the following use cases:

1. [**Create Project and Issue**](https://github.com/ballerina-platform/module-ballerinax-jira/tree/main/examples/create_project_and_issue/) : Creates a new Jira project and adds an issue to it..
2. [**Create Issue and Add Comment**](https://github.com/ballerina-platform/module-ballerinax-jira/tree/main/examples/create_issue_and_add_comment/) : Creates a new issue in an existing Jira project and adds a comment to it.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`jira` package](https://central.ballerina.io/ballerinax/jira/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
