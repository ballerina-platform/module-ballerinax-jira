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

import ballerina/test;

configurable boolean isLiveServer = false;
configurable string username = "user";
configurable string password = "test";
configurable string domain = "";

final string serviceUrl = isLiveServer ?string `https://${domain}.atlassian.net/rest` : "http://localhost:9090";

isolated string? issueId = ();
isolated string? profileId = ();
isolated string? projectKey = "PID205";

ConnectionConfig config = {
    auth: {
        username,
        password
    }
};

final Client jiraClient = check new (config, serviceUrl);

@test:Config {}
isolated function testGetUser() returns error? {
    User user = check jiraClient->/api/'3/myself;
    if user.accountId is string {
        lock {
            profileId = <string>user.accountId;
        }
    }
    test:assertNotEquals(user.accountId, "");
}

@test:Config {
    dependsOn: [testGetUser],
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateProject() returns error? {
    string prokey = "";
    string accountId = "";
    lock {
        prokey = projectKey ?: "project key is null";

    }
    lock {
        accountId = profileId ?: "profile id is null";
    }
    CreateProjectDetails payload = {
        'key: prokey,
        name: "Test Project For Ballerina Connector2",
        projectTypeKey: "business",
        leadAccountId: accountId
    };
    ProjectIdentifiers response = check jiraClient->/api/'3/project.post(payload);
    test:assertNotEquals(response.id, "");
}

@test:Config {
    dependsOn: [testCreateProject],
    groups: ["live_tests", "mock_tests"]
}
isolated function testCreateIssue() returns error? {
    string prokey = "";
    lock {
        prokey = projectKey ?: "project key is null";
    }
    IssueUpdateDetails payload = {
        fields: {
            "project": {"key": prokey},
            "summary": "sample test issue",
            "description": {"type": "doc", "version": 1, "content": [{"type": "paragraph", "content": [{"type": "text", "text": "Ballerina connector sample Test Issue"}]}]},
            "issuetype": {"name": "Task"}
        }
    };
    CreatedIssue response = check jiraClient->/api/'3/issue.post(payload);
    if response.id is string {
        lock {
            issueId = <string>response.id;
        }
    }
    test:assertNotEquals(response.id, "");
}

@test:Config {
    dependsOn: [testCreateIssue],
    groups: ["live_tests", "mock_tests"]
}
isolated function testGetIssue() returns error? {

    string id = "";
    lock {
        id = issueId ?: "issueId is null";
    }
    GetIssueQueries queries = {
        fields: ["summery", "description", "status", "created", "project", "comment"]
    };
    IssueBean issue = check jiraClient->/api/'3/issue/[id].get({}, queries);
    test:assertNotEquals(issue.key, ());
}

@test:Config {
    dependsOn: [testCreateProject],
    groups: ["live_tests", "mock_tests"]
}
isolated function testAddActorsToProject() returns error? {
    string prokey = "";
    string accountId = "";
    lock {
        prokey = projectKey ?: "project key is null";
    }
    lock {
        accountId = profileId ?: "profile id is null";
    }
    ActorsMap payload = {
        user: [accountId]
    };
    ProjectRole role = check jiraClient->/api/'3/project/[prokey]/role/[10002].post(payload);
    test:assertNotEquals(role.id, ());
}

@test:Config {
    dependsOn: [testCreateProject, testCreateIssue, testAddActorsToProject, testUpdateIssue],
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteIssue() returns error? {
    string id = "";
    lock {
        id = issueId ?: "issueId is null";
    }
    DeleteIssueQueries queries = {
        deleteSubtasks: "true"
    };
    check jiraClient->/api/'3/issue/[id].delete({}, queries);
    test:assertTrue(true, msg = "Issue deleted successfully.");
}

@test:Config {
    dependsOn: [testCreateProject, testCreateIssue],
    groups: ["live_tests", "mock_tests"]
}
isolated function testUpdateIssue() returns error? {
    string id = "";
    lock {
        id = issueId ?: "issueId is null";
    }
    IssueUpdateDetails payload = {
        update: {
            "summary": [{set: "updated summery"}],
            "description": [{set: "updated description"}]
        }
    };
    json|error response = jiraClient->/api/'3/issue/[id].put(payload);

    if response is json {
        test:assertNotEquals(response, ());
    }
}

@test:Config {
    dependsOn: [testDeleteIssue],
    groups: ["live_tests", "mock_tests"]
}
isolated function testDeleteProject() returns error? {
    string prokey = "";
    lock {
        prokey = projectKey ?: "project key is null";
    }
    DeleteProjectQueries queries = {
        enableUndo: false
    };
    check jiraClient->/api/'3/project/[prokey].delete({}, queries);
    test:assertTrue(true, msg = "Project deleted successfully.");
}
