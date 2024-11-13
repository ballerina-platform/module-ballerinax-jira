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


