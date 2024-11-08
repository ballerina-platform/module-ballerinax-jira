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
import ballerina/os;
import ballerina/http;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string serviceUrl = isLiveServer ? os:getEnv("SERVICE_URL") : "http://localhost:9090";
configurable string token = isLiveServer ? os:getEnv("JIRA_TOKEN") : "test";
configurable string username = isLiveServer ? os:getEnv("JIRA_USERNAME") : "test@example.com";
ConnectionConfig config = {
    auth: <http:CredentialsConfig>{
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
    Dashboard response = check jira->/rest/api/'3/dashboard.post(payload={
        name: "Ansak's dashboard",
        description: "A dashboard to help auditors identify sample of issues to check.",
        sharePermissions: [
        ],
        editPermissions: []
    });
        test:assertNotEquals(response.id, null, msg = "Dashboard id should not be empty.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetDefaultShareScope() returns error? {
    // Call the get default share scope function
    DefaultShareScope response = check jira->/rest/api/'3/filter/defaultShareScope();

    // Assertion: Check that 'scopeType' exists in the response
        test:assertNotEquals(response.scope,"", msg = "Expected 'scope' to have a value");
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

    // Call the get function without any query parameters
Filter[]|error response = jira->/rest/api/'3/filter/favourite();

if (response is Filter[]) {
    // Verify live response has at least one Filter object
    test:assertNotEquals(response.length(), 0, msg = "No Favourite Filters.");
} else {
    test:assertFail(msg = "Error occurred while fetching favourite filters: " + response.toString());
}
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetMyFilters() returns error? {
    // Call the get function without any query parameters
    Filter[]|error response = jira->/rest/api/'3/filter/my();

    // Assert that response is an array of Filter objects and check the array is not empty
    test:assertTrue(response is Filter[], msg = "Expected response to be an array of Filter objects.");
    if response is Filter[] {
        test:assertNotEquals(response.length(), 0, msg = "There are no My Filters.");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testPostGroup() returns error? {
    

    // Call the function to create a group
    Group|error response = jira->/rest/api/'3/group.post(payload = {name: "first group"});

    // Validate the response
    test:assertTrue(response is Group, msg = "Expected response to be a Group object.");
    if response is Group {
        test:assertEquals(response.name, "first group", msg = "Group name does not match the expected value.");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteGroup() returns error? {

    // Call the function to delete the specified group
    http:Response|error response = jira->/rest/api/'3/group.delete(queries={groupname: "first group"});

    // Validate the response
    test:assertTrue(response is http:Response, msg = "Expected a HTTP Response object.");
    if response is http:Response {
        test:assertEquals(response.statusCode, 200, msg = "Expected HTTP status code 200 indicating successful deletion.");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAllFieldConfigurations() returns error? {
   
    // Call the function to get all field configurations
    PageBeanFieldConfigurationDetails|error response = jira->/rest/api/'3/fieldconfiguration();

    // Validate the response
    if response is PageBeanFieldConfigurationDetails {
        test:assertTrue(response.total > 0, msg = "There is no field configuration");
    }
    //for mock validation
    if response is json {
        test:assertTrue(response.total > 0, msg = "There is no field configuration");
    }
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAllFields() returns error? {

    // Call the function to get all fields
    FieldDetails[]|error response = jira->/rest/api/'3/'field();

    // Validate the response
    if response is FieldDetails[] {
        test:assertNotEquals(response.length(), 0, msg = "Expected field details array to be non-empty.");
    } else {
        test:assertFail(msg = "Expected a FieldDetails[] response.");
    }
}