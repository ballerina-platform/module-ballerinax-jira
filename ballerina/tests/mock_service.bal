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

listener http:Listener httpListener = new (9090);

service / on httpListener {

    resource function get rest/api/'3/myself() returns User {
        return {
            "name": "Mia Krystof",
            "active": true
        };
    }

    // Mock response for `getMyPermissions`
    resource function get rest/api/'3/mypermissions(http:Caller caller, http:Request req) returns error? {
        Permissions permissionsResponse = {
            permissions: {
                "BROWSE_PROJECTS": {
                    id: "10",
                    key: "BROWSE_PROJECTS",
                    name: "Browse Projects",
                    description: "Ability to browse projects and the issues within them.",
                    havePermission: true 
                }
            }
        };

        // Send the mock response for permissions
        check caller->respond(permissionsResponse);
    }

    // Mock response for `post rest/api/'3/role`
    resource function post rest/api/'3/role(http:Caller caller, CreateUpdateRoleRequestBean payload) returns error? {
        // Return a single ProjectRole, not an array
        ProjectRole roleResponse = {
            id: 101,
            name: payload.name,
            description: payload.description
            // Include additional fields as needed
        };

        // Send back the mock role response as a single object
        check caller->respond(roleResponse);
    }

     // New mock for `delete rest/api/'3/role/[int id]`
    resource function delete rest/api/'3/role/[int id](http:Caller caller, http:Request req) returns error? {
        // Return a response with status code 204 (No Content)
        http:Response response = new;
        response.statusCode = 204;
        check caller->respond(response);
    }

    resource function post rest/api/'3/project(http:Caller caller, http:Request req) returns error? {
        // Directly send a mock response without checking the payload
        ProjectIdentifiers mockResponse = {
            id: 10001,
            key: "EX",
            self: "http://example.com/project/10001"
        };

        check caller->respond(mockResponse);
    }

    resource function get rest/api/'3/project/[string projectKeyOrId]/securitylevel(http:Caller caller, http:Request req) returns error? {
        ProjectIssueSecurityLevels mockResponse = {
            levels: [
                {
                    id: "10000",
                    name: "Default Security Level",
                    description: "This is the default security level."
                }
            ]
        };
        check caller->respond(mockResponse);
    }

    resource function get rest/api/'3/applicationrole(http:Caller caller, http:Request req) returns error? {
        json mockResponse = [
            {
                "key": "jira-software",
                "groups": ["org-admins", "jira-users-mohamedansak", "atlassian-addons-admin"],
                "groupDetails": [
                    { "name": "atlassian-addons-admin", "groupId": "73c9dc3e-e647-46a6-a10b-2ed26fd527da" },
                    { "name": "jira-users-mohamedansak", "groupId": "e5248ad2-8cc6-4982-87cb-8987149bf3ab" },
                    { "name": "org-admins", "groupId": "641a88ad-809c-4706-a663-895191ae7d29" }
                ],
                "name": "Jira Software",
                "defaultGroups": ["jira-users-mohamedansak"],
                "defaultGroupsDetails": [
                    { "name": "jira-users-mohamedansak", "groupId": "e5248ad2-8cc6-4982-87cb-8987149bf3ab" }
                ],
                "selectedByDefault": false,
                "defined": true,
                "numberOfSeats": 35000,
                "remainingSeats": 34998,
                "userCount": 2,
                "userCountDescription": "users",
                "hasUnlimitedSeats": false,
                "platform": false
            }
        ];
        check caller->respond(mockResponse);
    }

    // Mock endpoint to retrieve a specific ApplicationRole based on key
     // Mock endpoint to retrieve a specific ApplicationRole based on key
    resource function get rest/api/'3/applicationrole/[string key](http:Caller caller, http:Request req) returns error? {
        if key == "jira-software" {
            json mockResponse = {
                "key": "jira-software",
                "name": "Jira Software"
            };
            check caller->respond(mockResponse);
        } else {
            check caller->respond("ApplicationRole not found");
        }
    }

    // Mock endpoint for auditing records
    resource function get rest/api/'3/auditing/'record(http:Caller caller, http:Request req) returns error? {
        // Mock response with a sample record for testing
        json mockResponse = {
            "records": [
                {
                    "id": 1001,
                    "summary": "User logged in",
                    "created": "2023-10-25T12:34:56.000Z",
                    "category": "authentication"
                }
            ]
        };
        check caller->respond(mockResponse);
    }

     resource function get rest/api/'3/classification\-levels(http:Caller caller, http:Request req) returns error? {
        // Mock response mimicking a successful response with `classifications` key
        json mockResponse = {
            "classifications": []
        };
        check caller->respond(mockResponse);
    }

     resource function get rest/api/'3/dashboard(http:Caller caller, http:Request req) returns error? {
        // Mock response mimicking the structure of PageOfDashboards
        json mockResponse = {
            "dashboards": []
        };
        check caller->respond(mockResponse);
    }

    resource function post rest/api/'3/dashboard(http:Caller caller, http:Request req) returns error? {
        // Mock response body mimicking the actual API response
        json mockResponse = {
            "name": "Auditors dashboard",
            "id":"10001",
            "description": "A dashboard to help auditors identify sample of issues to check.",
            "sharePermissions": [],
            "editPermissions": []
        };
        check caller->respond(mockResponse);
    }

    resource function get rest/api/'3/filter/defaultShareScope(http:Caller caller, http:Request req) returns error? {
        // Mock response with a default share scope
        json mockResponse = {
            "scope": "GLOBAL"
        };

        // Send the mock response
        check caller->respond(mockResponse);
    }

    resource function put rest/api/'3/filter/defaultShareScope(http:Caller caller, http:Request req) returns error? {

        // Mock response, echoing the request scope value
        json mockResponse = {
            "scope":"AUTHENTICATED"
        };

        // Send the mock response
        check caller->respond(mockResponse);
    }

    resource function get rest/api/'3/filter/favourite(http:Caller caller, http:Request req) returns error? {
        // Mock response with an array of Filter objects
        json mockResponse = [
            {
                "id": "10000",
                "name": "My Favorite Filter",
                "description": "This is a mock description for the favorite filter."
            },
            {
                "id": "10001",
                "name": "Another Favorite Filter",
                "description": "Description for another favorite filter."
            }
        ];

        // Send the mock response
        check caller->respond(mockResponse);
    }

    resource function get rest/api/'3/filter/my(http:Caller caller, http:Request req) returns error? {
        // Mock response with an array of Filter objects
        json mockResponse = [
            {
                "id": "20000",
                "name": "My Mock Filter",
                "description": "This is a mock description for my filter."
            },
            {
                "id": "20001",
                "name": "Another Mock Filter",
                "description": "Description for another mock filter."
            }
        ];

        // Send the mock response
        check caller->respond(mockResponse);
    }

    resource function post rest/api/'3/group(http:Caller caller, http:Request req) returns error? {
            json mockResponse = {
                "name": "first group",
                "groupId": "12345",
                "self": "http://localhost:9090/rest/api/3/group?groupId=12345"
            };
            check caller->respond(mockResponse);
    }

    resource function delete rest/api/'3/group(http:Caller caller, http:Request req) returns error? { 
            http:Response mockResponse = new;
            mockResponse.statusCode = 200;
            mockResponse.setHeader("x-mock-confirmation", "Group 'first group' deleted successfully");

            // Send the mock response
            check caller->respond(mockResponse);
    }

    resource function get rest/api/'3/fieldconfiguration(http:Caller caller, http:Request req) returns error? {
        // Create a mock response
        json mockResponse = {
            "startAt": 0,
            "maxResults": 50,
            "total": 10,  // Total field configurations, set to >0 for testing
            "values": [
                {
                    "id": "1",
                    "name": "Default Field Configuration",
                    "description": "The default field configuration",
                    "isDefault": true
                },
                {
                    "id": "2",
                    "name": "Custom Field Configuration",
                    "description": "A custom field configuration",
                    "isDefault": false
                }
            ]
        };

        // Send the mock response
        http:Response res = new;
        res.statusCode = 200;
        res.setPayload(mockResponse);
        check caller->respond(res);
    }

    resource function get rest/api/'3/'field(http:Caller caller, http:Request req) returns error? {
        // Create a mock response
        json mockResponse = [
            {
                "id": "customfield_10000",
                "name": "Story Points",
                "custom": true,
                "orderable": true,
                "navigable": true,
                "searchable": true,
                "schema": {
                    "type": "number",
                    "custom": "com.atlassian.jira.plugin.system.customfieldtypes:float",
                    "customId": 10000
                }
            },
            {
                "id": "summary",
                "name": "Summary",
                "custom": false,
                "orderable": true,
                "navigable": true,
                "searchable": true,
                "schema": {
                    "type": "string",
                    "system": "summary"
                }
            }
        ];

        // Send the mock response
        http:Response res = new;
        res.statusCode = 200;
        res.setPayload(mockResponse);
        check caller->respond(res);
    }
}


