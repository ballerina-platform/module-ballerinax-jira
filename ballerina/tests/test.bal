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