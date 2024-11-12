import ballerina/http;
import ballerina/io;
import ballerinax/jira;
import ballerina/os;

configurable string serviceUrl =os:getEnv("SERVICE_URL"); 
configurable string token = os:getEnv("JIRA_TOKEN");
configurable string username = os:getEnv("JIRA_USERNAME");
jira:ConnectionConfig config = {
    auth: <http:CredentialsConfig>
    {
        username: username,
        password: token
    }
};
final jira:Client jira = check new (config, serviceUrl);

public function main() returns error? {

    // Make the API call to create a project
    jira:ProjectIdentifiers project = check jira->/rest/api/'3/project.post(
        payload=
        {
            key: "EX",
            name: "Example",
            projectTypeKey: "business",
            leadAccountId:"712020:5d71be5f-debd-474f-9ec9-a97b9023ea4e"
        }
    );
    io:println("Project created with ID: ", project.id);
}


