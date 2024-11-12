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

import ballerina/http;
import ballerina/test;
import ballerina/os;


configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string serviceUrl = isLiveServer ? os:getEnv("SERVICE_URL") : "http://localhost:9090";
configurable string token = isLiveServer ? os:getEnv("JIRA_TOKEN") : "test";
configurable string username = isLiveServer ? os:getEnv("JIRA_USERNAME") : "test@example.com";
ConnectionConfig config = {
    auth: <http:CredentialsConfig>
    {
        username: username,
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
    test:assertNotEquals(response.name, (), "Name cannot be null");
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
    test:assertTrue(response?.permissions["BROWSE_PROJECTS"]?.havePermission ?: false, "Do not have permission to browse projects");
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
    test:assertEquals(response.name, "Developer", "Role name does not match.");
    test:assertEquals(response.description, "Role for developers", "Role description does not match.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteRole() returns error? {
    // Define the role ID to delete
    int roleId = 10009; 
    http:Response response = check jira->/rest/api/'3/role/[roleId].delete();

    // Assertions to verify that deletion was successful
    test:assertEquals(response.statusCode, 204, "Expected 204 No Content status for successful deletion.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateProject() returns error? {

    // Call the `createProject` endpoint.
    ProjectIdentifiers response = check jira->/rest/api/'3/project.post(
        payload=
        {
            key: "EX",
            name: "Example",
            projectTypeKey: "business",
            leadAccountId:"712020:5d71be5f-debd-474f-9ec9-a97b9023ea4e"
        }
    );
    test:assertNotEquals(response.id,null, "Unsuccessful project creation");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetProjectSecurityLevelLive() returns error? {
    string projectKeyOrId = "EX";  // Specify a valid project key or ID here

    // Call the live API to retrieve the security level details for the project.
    ProjectIssueSecurityLevels response = check jira->/rest/api/'3/project/[projectKeyOrId]/securitylevel();

    // Assertions to verify expected properties in the live response
    test:assertNotEquals(response.levels.length(), 0, "No security levels found for project.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetApplicationRoles() returns error? {
    ApplicationRole[] response = check jira->/rest/api/'3/applicationrole();

    // Validate the array is not empty and has expected properties in each item.
    test:assertNotEquals(response.length(), 0, "Expected non-empty application roles array");

    foreach var role in response {
        test:assertNotEquals(role.name, "", "Application role name should not be empty");
        test:assertNotEquals(role.key, "", "Application role key should not be empty");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetSpecificApplicationRole() returns error? {
    string ProjectKey = "jira-software";

    ApplicationRole response = check jira->/rest/api/'3/applicationrole/[ProjectKey];

    // Assertions
    test:assertEquals(response.key, "jira-software", msg = "Expected key to be 'jira-software'");
    test:assertEquals(response.name, "Jira Software", msg = "Expected name to be 'Jira Software'");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAuditRecords() returns error? {
    // Call the function without any query parameters
    AuditRecords response = check jira->/rest/api/'3/auditing/'record();
    // Assertions
   test:assertNotEquals(response.records, null, "Expected 'records' array to be non-empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetClassificationLevels() returns error? {
    // Invoke the function without query parameters.
    DataClassificationLevelsBean response = check jira->/rest/api/'3/classification\-levels();

    // Check the response status code for both live and mock tests
    test:assertTrue(response?.classifications is json[], "Expected 'classifications' key to be present in the response.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetDashboards() returns error? {
    // Invoke the function without query parameters.
    PageOfDashboards response = check jira->/rest/api/'3/dashboard();

    // Check that the `dashboards` key exists and is an array in the response
    test:assertTrue(response?.dashboards is Dashboard[], msg = "Expected 'dashboards' key to be present in the response and to be an array.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateDashboard() returns error? {

    // Call the post function
    Dashboard response = check jira->/rest/api/'3/dashboard.post(payload = {
        name: "Ansak's dashboard",
        description: "A dashboard to help auditors identify sample of issues to check.",
        sharePermissions: [],
        editPermissions: []
    });
    test:assertNotEquals(response.id, null, "Dashboard id should not be empty.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetDefaultShareScope() returns error? {
    // Call the get default share scope function
    DefaultShareScope response = check jira->/rest/api/'3/filter/defaultShareScope();

    // Assertion: Check that 'scopeType' exists in the response
    test:assertNotEquals(response.scope, "", "Expected 'scope' to have a value");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testPutDefaultShareScope() returns error? {
    // Call the put function
    DefaultShareScope response = check jira->/rest/api/'3/filter/defaultShareScope.put(payload = {scope:"AUTHENTICATED" });

    // Assertion: Check that the response contains the expected scope value
    
    test:assertEquals(response.scope, "AUTHENTICATED", msg = "Expected 'scope' to be 'AUTHENTICATED'");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetFavouriteFilters() returns error? {

  Filter[] response = check jira->/rest/api/'3/filter/my();

  test:assertNotEquals(response.length(), 0, "There are no My Filters.");

}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetMyFilters() returns error? {

    Filter[] response = check jira->/rest/api/'3/filter/my();

    test:assertNotEquals(response.length(), 0, "There are no My Filters.");

}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testPostGroup() returns error? {

    // Call the function to create a group
    Group response = check jira->/rest/api/'3/group.post(payload = {name: "first group"});

    //Assertation
    test:assertEquals(response.name, "first group", "Group name does not match the expected value.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteGroup() returns error? {

    // Call the function to delete the specified group
    http:Response response = check jira->/rest/api/'3/group.delete(queries = {groupname: "first group"});
    // Validate the response
    test:assertEquals(response.statusCode, 200, "Expected HTTP status code 200 indicating successful deletion.");

}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAllFieldConfigurations() returns error? {

    PageBeanFieldConfigurationDetails response = check jira->/rest/api/'3/fieldconfiguration();

    test:assertTrue(response.total > 0, "There is no field configuration");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAllFields() returns error? {

   FieldDetails[] response = check jira->/rest/api/'3/'field();

   test:assertNotEquals(response.length(), 0, "Expected field details array to be non-empty.");

}