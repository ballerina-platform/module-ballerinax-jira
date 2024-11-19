# Ballerina Jira connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-jira/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-jira/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-jira/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-jira/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-jira/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-jira/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-jira.svg)](https://github.com/ballerina-platform/module-ballerinax-jira/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/jira.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%jira)

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

<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/try-jira-cloud#5.png alt="Try jira" style="width: 70%;">

2. Click on the try cloud button under Jira.

<img src=https://raw.githubusercontent.com/ballerina-platform/module-ballerinax-jira/main/docs/setup/resources/integrate-Jira#4.png alt="Integrate Jira" style="width: 70%;">

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

final jira:Client jiraClient = check new({
    baseUrl: baseUrl,
    auth: {
        username: username,
        password: apiToken
    }
});
```
### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### create an issue

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

1. [Jira-project-and-issue-management](https://github.com/ballerina-platform/module-ballerinax-jira/blob/main/examples/JiraProjectManagement/main.bal)

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

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
