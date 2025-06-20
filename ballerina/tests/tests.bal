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
import ballerina/os;
import ballerina/auth;

configurable boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
configurable string userId = isLiveServer? os:getEnv("JIRA_USER_NAME") : "test@gmail.com";
configurable string userApiToken = isLiveServer ? os:getEnv("JIRA_TOKEN") : "test";
configurable string jiraDomain = isLiveServer? os:getEnv("JIRA_DOMAIN") : "";



final string serviceUrl = isLiveServer? "https://"+ jiraDomain + ".atlassian.net/rest" : "http://localhost:9090";

isolated string? issueId = ();
isolated string? profileId = ();
isolated string? projectKey = "PID205";

ConnectionConfig config = {auth: {
  username: userId,
  password: userApiToken
}};

auth:CredentialsConfig config2 = {
  username: userId,
  password: userApiToken
};
final readonly & map<string|string[]> header = {
  "Authorization": "Basic "+ config2.toBalString()
};

final Client jiraClient = check new(config, serviceUrl);

// testing the get user
@test:Config{}
isolated function testGetUser() returns error?{
    User user = check jiraClient->/api/'3/myself.get();
    if user.accountId is string {
      lock {
        profileId = <string>user.accountId;
      }
    }
    test:assertNotEquals(user.accountId,"");
}

// testing the project creation
@test:Config{
  dependsOn: [testGetUser]
}
isolated function testCreateProject() returns error?{
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
  ProjectIdentifiers response = check  jiraClient-> /api/'3/project.post(payload);
  test:assertNotEquals(response.id,"");
}

// testing create an issue
@test:Config{
  dependsOn: [testCreateProject]
}
isolated function testCreateIssue() returns error?{
  string prokey = "";
  lock {
    prokey = projectKey ?: "project key is null";
  }
    IssueUpdateDetails payload = {
        fields: {
            "project": {"key":prokey},
            "summary": "sample test issue",
            "description": {"type":"doc","version":1,"content":[{"type":"paragraph","content":[{"type":"text","text":"Ballerina connector sample Test Issue"}]}]},
            "issuetype": {"name": "Task"}
        }
    };
    CreatedIssue response = check jiraClient-> /api/'3/issue.post(payload);
    if response.id is string {
      lock {
        issueId = <string>response.id;
      }
    }
    test:assertNotEquals(response.id,"");
}

//testing get issue
@test:Config{
  dependsOn: [testCreateIssue]
}
isolated function testGetIssue() returns error?{
    
  string id = "";
  lock {
    id = issueId ?: "issueId is null";
  }
  GetIssueQueries queries = {
      fields: ["summery","description","status","created","project","comment"]
  };
  IssueBean issue = check jiraClient-> /api/'3/issue/[id].get(header,queries);
  test:assertNotEquals(issue.key,());
}

// test add actors to project
@test:Config{
  dependsOn: [testCreateProject]
}
isolated function testAddActorsToProject() returns error?{
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
  ProjectRole role = check jiraClient->/api/'3/project/[prokey]/role/[10002].post(payload,header);
  test:assertNotEquals(role.id,());
}

// test Delete issue
@test:Config{
  dependsOn: [testCreateProject,testCreateIssue,testAddActorsToProject,testUpdateIssue]
}
isolated function testDeleteIssue() returns error?{
    string id = "";
    lock {
      id = issueId ?: "issueId is null";
    }
  DeleteIssueQueries queries = {
    deleteSubtasks: "true"
  };
    check jiraClient->/api/'3/issue/[id].delete(header,queries);
    test:assertTrue(true, msg = "Issue deleted successfully.");
}

// testing edit issue
@test:Config{
  dependsOn: [testCreateProject,testCreateIssue]
}
isolated function testUpdateIssue() returns error?{
    string id = "";
    lock {
      id = issueId ?: "issueId is null";
    }
    IssueUpdateDetails payload = {
        update: {
            "summary":[{set:"updated summery"}],
            "description": [{set:"updated description"}]
        }
    };
    json | error response = jiraClient-> /api/'3/issue/[id].put(payload);

    if (response is json) {
        test:assertNotEquals(response,());
    }
}

@test:Config{
  dependsOn: [testDeleteIssue]
}
isolated function testDeleteProject() returns error?{
  string prokey = "";
  lock {
    prokey = projectKey ?: "project key is null";
  }
  DeleteProjectQueries queries = {
    enableUndo: false
  };
  check jiraClient->/api/'3/project/[prokey].delete(header,queries);
  test:assertTrue(true, msg = "Project deleted successfully.");
}


