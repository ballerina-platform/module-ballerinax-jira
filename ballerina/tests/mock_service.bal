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

import ballerina/http;
import ballerina/io;
import ballerina/log;

listener http:Listener httpListener = new (9090);

http:Service mockService = service object {
    resource function get api/'3/myself() returns User|error {
        User user = {
            accountId: "12345"
        };
        return user;
    }

    resource function post api/'3/issue() returns CreatedIssue|error {
        CreatedIssue issue = {
            id: "12345"
        };

        return issue;
    }

    resource function get api/'3/issue/[string projectKey]() returns IssueBean|error {
        IssueBean response = {
            id: "12345",
            'key: "Test_Issue"
        };
        return response;
    }

    resource function put api/'3/issue/[string id]() returns json|error {
        json response = {
            id: "12345"
        };
        return response;
    }

    resource function delete api/'3/issue/[string id]() returns error? {
        return;
    }

    resource function post api/'3/project() returns ProjectIdentifiers|error {
        ProjectIdentifiers response = {
            id: 121231432432,
            'key: "TP1",
            self: ""
        };
        return response;
    }

    resource function post api/'3/project/[string projectId]/role/[int roleId](@http:Payload ActorsMap payload) returns ProjectRole|error {
        ProjectRole response = {
            id: 5555555555
        };
        return response;
    }

    resource function delete api/'3/project/[string id](http:Request req) returns error? {
        var authHeaderResult = check req.getHeader("Authorization");
        if authHeaderResult is string {
            io:println("Authorization header: ", authHeaderResult);
        }
        return;
    }
};

function init() returns error? {
    if isLiveServer {
        log:printInfo("Skiping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
