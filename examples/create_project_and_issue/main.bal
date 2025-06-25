// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
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

import ballerina/auth;
import ballerinax/jira;
import ballerina/log;

configurable string jiraToken = ?;
configurable string jiraUsername = ?;
configurable string jiraDomain = ?;

string projectKey = "PID205";

jira:ConnectionConfig config = {
    auth: {
        username: jiraUsername,
        password: jiraToken
    }
};

auth:CredentialsConfig authHeaderConfig = {
    username: jiraUsername,
    password: jiraToken
};
final map<string|string[]> headerConfig = {
    "Authorization": "Basic " + authHeaderConfig.toBalString()
};
string serviceUrl = "https://" + jiraDomain + ".atlassian.net/rest";

jira:Client jiraClient = check new (config, serviceUrl);

public function main() returns error? {

    jira:User user = check jiraClient->/api/'3/myself.get();

    string id = check user.accountId.ensureType();
    log:printInfo("userId retrieved",Id=id);

    jira:CreateProjectDetails payload = {
        'key: projectKey,
        name: "Test Project For Ballerina Connector2",
        projectTypeKey: "business",
        leadAccountId: id
    };

    jira:ProjectIdentifiers project = check jiraClient->/api/'3/project.post(payload);
    log:printInfo("New project created",Projects = project.'key);

    jira:IssueUpdateDetails issuePayload = {
        fields: {
            "project": {"key":project.key},
            "summary": "sample test issue",
            "description": {"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"Ballerina connector sample Test Issue"}]}]},
            "issuetype": {"name": "Task"}
        }
    };

    jira:CreatedIssue issue = check jiraClient->/api/'3/issue.post(issuePayload);
    log:printInfo("New Issue added",IssueCreated=issue.'key, Projects=project.'key);
}
