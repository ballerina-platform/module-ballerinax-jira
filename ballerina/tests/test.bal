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

    test:assertEquals(response.name,"Mia Krystof", "Name cannot be null");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetMyPermissions() returns error? {
    GetMyPermissionsQueries queryParams = {
        permissions: "BROWSE_PROJECTS"
    };

    Permissions response = check jira->/rest/api/'3/mypermissions(queries = queryParams);

    test:assertTrue(response?.permissions["BROWSE_PROJECTS"]?.havePermission ?: false, "Do not have permission to browse projects");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateRole() returns error? {
    ProjectRole response = check jira->/rest/api/'3/role.post(
        payload = {
            name: "Developer",
            description: "Role for developers"
        }
    );

    test:assertEquals(response.name, "Developer", "Role name does not match.");
    test:assertEquals(response.description, "Role for developers", "Role description does not match.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteRole() returns error? {
    int roleId = 10009; 
    http:Response response = check jira->/rest/api/'3/role/[roleId].delete();

    test:assertEquals(response.statusCode, 204, "Expected 204 No Content status for successful deletion.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateProject() returns error? {
    ProjectIdentifiers response = check jira->/rest/api/'3/project.post
    (
        payload =
        {
            key: "EX",
            name: "Example",
            projectTypeKey: "business",
            leadAccountId:"712020:5d71be5f-debd-474f-9ec9-a97b9023ea4e"
        }
    );

    test:assertEquals(response.id, 10001, "Unsuccessful project creation");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetProjectSecurityLevelLive() returns error? {
    string projectKeyOrId = "EX";  
    ProjectIssueSecurityLevels response = check jira->/rest/api/'3/project/[projectKeyOrId]/securitylevel();

    test:assertEquals(response.levels[0].id, "10000", "No security levels found for project.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetApplicationRoles() returns error? {
    ApplicationRole[] response = check jira->/rest/api/'3/applicationrole();

    test:assertNotEquals(response.length(), 0, "Expected non-empty application roles array");
    test:assertEquals(response[0].name, "Jira Software", "Application role name should not be empty");
    test:assertEquals(response[0].key, "jira-software", "Application role key should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetSpecificApplicationRole() returns error? {
    string ProjectKey = "jira-software";
    ApplicationRole response = check jira->/rest/api/'3/applicationrole/[ProjectKey];

    test:assertEquals(response.key, "jira-software", "Expected key to be 'jira-software'");
    test:assertEquals(response.name, "Jira Software", "Expected name to be 'Jira Software'");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetAuditRecords() returns error? {
    AuditRecords response = check jira->/rest/api/'3/auditing/'record();
  
    test:assertNotEquals(response.total, 0, "Expected 'records' array to be non-empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetClassificationLevels() returns error? {
    DataClassificationLevelsBean response = check jira->/rest/api/'3/classification\-levels();

    test:assertTrue(response?.classifications is json[], "Expected 'classifications' key to be present in the response.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetDashboards() returns error? {
    PageOfDashboards response = check jira->/rest/api/'3/dashboard();

    test:assertTrue(response?.dashboards is Dashboard[], msg = "Expected 'dashboards' key to be present in the response and to be an array.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateDashboard() returns error? {
    Dashboard response = check jira->/rest/api/'3/dashboard.post(payload = {
        name: "Ansak's dashboard",
        description: "A dashboard to help auditors identify sample of issues to check.",
        sharePermissions: [],
        editPermissions: []
    });

    test:assertEquals(response.id, "10001", "Dashboard id should not be empty.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetDefaultShareScope() returns error? {
    DefaultShareScope response = check jira->/rest/api/'3/filter/defaultShareScope();

    test:assertEquals(response.scope, "GLOBAL", "Expected 'scope' to be 'GLOBAL'");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testPutDefaultShareScope() returns error? {
    DefaultShareScope response = check jira->/rest/api/'3/filter/defaultShareScope.put(payload = {scope:"AUTHENTICATED"});
    
    test:assertEquals(response.scope, "AUTHENTICATED", msg = "Expected 'scope' to be 'AUTHENTICATED'");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetFavouriteFilters() returns error? {
  Filter[] response = check jira->/rest/api/'3/filter/favourite();

  test:assertEquals(response[0].id, "10000", "No favourite filter with the specified ID");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetMyFilters() returns error? {
    Filter[] response = check jira->/rest/api/'3/filter/my();

    test:assertEquals(response[0].id, "20000", "Filter ID not match");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testPostGroup() returns error? {
    Group response = check jira->/rest/api/'3/group.post(payload = {name: "first group"});

    test:assertEquals(response.name, "first group", "Group name does not match the expected value.");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteGroup() returns error? {
    http:Response response = check jira->/rest/api/'3/group.delete(queries = {groupname: "first group"});

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

   test:assertEquals(response[0].id, "customfield_10000", "Expected field details array to be non-empty.");
}