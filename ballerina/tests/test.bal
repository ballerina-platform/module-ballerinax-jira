// Copyright (c) 2024 WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
//import ballerina/os;
import ballerina/log;
import ballerina/http;

//configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable boolean isLiveServer = true;
configurable string serviceUrl = isLiveServer ? "https://mohamedansak.atlassian.net" : "http://localhost:9090";
//configurable string token = isLiveServer ? os:getEnv("JIRA_TOKEN") : "test";
configurable string token = "ATATT3xFfGF0J-gMHkzurh1-YbGBkELQsjv4hIIOV3Qeypm01gNIgbABQBfgBFy8u2TFuYLfiBDcX06l7W9eb-N9ZctJMuFvVVlHTc6q5GF-c9rKEX6zeH6CKyAEiFKKLGtMQTl8KhGNyBf91TP7t5AyKCCNgKswMGpjK1nkIBdNxFsAuaIHo6M=901C9DE1";
//configurable string username = isLiveServer ? os:getEnv("JIRA_USERNAME") : "test@example.com";
ConnectionConfig config = {
    auth: <http:CredentialsConfig>{
        username: "mohamedansak@gmail.com",
        password: token
    }
};
final Client jira = check new Client(config, serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetMyself() returns error? {
    User response = check jira->/rest/api/'3/myself;

    // Assertions
    test:assertNotEquals(response,(),"Myself data cannot be null");
}


@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetMyPermissions() returns error? {
    // Define `queryParams` as a `GetMyPermissionsQueries` with a single string.
    GetMyPermissionsQueries queryParams = {
        permissions: "BROWSE_PROJECTS"
    };

    // Call the `getMyPermissions` endpoint.
    Permissions response = check jira->/rest/api/'3/mypermissions(queries = queryParams);

    boolean havePermission = response?.permissions["BROWSE_PROJECTS"]?.havePermission ?: false;
    test:assertTrue(havePermission, "Do not have permission to browse projects");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateRole() returns error? {

    // Call the `post rest/api/'3/role` endpoint with the payload
    ProjectRole response = check jira->/rest/api/'3/role.post(
        payload = {
            name: "Developer",
            description: "Role for developers"
        }
    );

    // Assertions
    test:assertEquals(response.name, "Developer", msg = "Role name does not match.");
    test:assertEquals(response.description, "Role for developers", msg = "Role description does not match.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteRole() returns error? {
    // Define the role ID to delete
    int roleId = 10009; 
    http:Response response = check jira->/rest/api/'3/role/[roleId].delete();

    // Assertions to verify that deletion was successful
    test:assertEquals(response.statusCode, 204, msg = "Expected 204 No Content status for successful deletion.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateProject() returns error? {

    // Call the `createProject` endpoint.
    ProjectIdentifiers response = check jira->/rest/api/'3/project.post(
        payload={
        key: "EX",
        name: "Example",
        projectTypeKey: "business",
        leadAccountId:"712020:5d71be5f-debd-474f-9ec9-a97b9023ea4e"
        }
    );
    test:assertNotEquals(response.id,null, msg = "Unsuccessful project creation");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetProjectSecurityLevelLive() returns error? {
    string projectKeyOrId = "EX";  // Specify a valid project key or ID here

    // Call the live API to retrieve the security level details for the project.
    ProjectIssueSecurityLevels response = check jira->/rest/api/'3/project/[projectKeyOrId]/securitylevel();

    

    // Assertions to verify expected properties in the live response
    test:assertNotEquals(response.levels.length(), 0, msg = "No security levels found for project.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetApplicationRoles() returns error? {
    ApplicationRole[] response = check jira->/rest/api/'3/applicationrole();

    // Validate the array is not empty and has expected properties in each item.
    test:assertNotEquals(response.length(), 0, msg = "Expected non-empty application roles array");

    foreach var role in response {
        test:assertNotEquals(role.name, "", msg = "Application role name should not be empty");
        test:assertNotEquals(role.key, "", msg = "Application role key should not be empty");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetSpecificApplicationRole() returns error? {
    string ProjectKey = "jira-software";

    ApplicationRole response = check jira->/rest/api/'3/applicationrole/[ProjectKey];

    // Assertions
    test:assertNotEquals(response.key, "", msg = "Expected 'key' to be non-empty");
    test:assertNotEquals(response.name, "", msg = "Expected 'name' to be non-empty");
    test:assertEquals(response.key, "jira-software", msg = "Expected key to be 'jira-software'");
    test:assertEquals(response.name, "Jira Software", msg = "Expected name to be 'Jira Software'");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAuditRecords() returns error? {
    // Call the function without any query parameters
    AuditRecords response = check jira->/rest/api/'3/auditing/'record();
    log:printInfo("Audit Records Response: " + response.toJsonString());
    // Assertions
   test:assertNotEquals(response.records,null, msg = "Expected 'records' array to be non-empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetClassificationLevels() returns error? {
    // Invoke the function without query parameters.
    DataClassificationLevelsBean response = check jira->/rest/api/'3/classification\-levels();

    // Check the response status code for both live and mock tests
    test:assertTrue(response?.classifications is json[], msg = "Expected 'classifications' key to be present in the response.");
}
