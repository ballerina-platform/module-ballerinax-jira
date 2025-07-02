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

import ballerina/io;
import ballerinax/jira;

configurable string password = "test-token";
configurable string username = "test-user";
configurable string domain = "test-domain";
configurable string projectKey = "PID205";

jira:ConnectionConfig config = {
    auth: {
        username,
        password
    }
};

string serviceUrl = string `https://${domain}.atlassian.net/rest`;

jira:Client jiraClient = check new (config, serviceUrl);

public function main() returns error? {

    jira:User user = check jiraClient->/api/'3/myself;
    string id = check user.accountId.ensureType();
    io:println(`User id retrieved: ${id}`);

    jira:IssueUpdateDetails issuePayload = {
        fields: {
            "project": {"key": projectKey},
            "summary": "2nd sample issue",
            "description": {
                'type: "doc",
                version: 1,
                content: [
                    {
                        'type: "paragraph",
                        content: [
                            {
                                'type: "text",
                                text: "Ballerina connector sample issue (type:task)02"
                            }
                        ]
                    }
                ]
            },
            "issuetype": {
                name: "Task"
            }
        }
    };

    jira:CreatedIssue issue = check jiraClient->/api/'3/issue.post(issuePayload);
    io:println(`New issue added: ${issue.id}`);

    string issueKey = check issue.key.ensureType();

    jira:Comment commentPayload = {
        author: {
            accountId: id,
            displayName: "your name"
        },
        body: {
            "type": "doc",
            "version": 1,
            "content": [
                {
                    "type": "paragraph",
                    "content": [
                        {
                            "type": "text",
                            "text": "Ballerina connector sample issue (type:task)-02"
                        }
                    ]
                }
            ]
        }
    };

    jira:Comment comment = check jiraClient->/api/'3/issue/[issueKey]/comment.post(commentPayload);
    io:println(`comment added: ${comment.id}`);
}
