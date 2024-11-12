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

    resource function get rest/api/'3/myself(string? expand) returns User|http:Unauthorized {
        return
        {
            "name": "Mia Krystof",
            "active": true
        };
    }
    

    // Mock response for `getMyPermissions`
    resource function get rest/api/'3/mypermissions(string? projectKey, string? projectId, string? issueKey, string? issueId, string? permissions, string? projectUuid, string? projectConfigurationUuid, string? commentId) returns Permissions|ErrorCollection|ErrorCollectionUnauthorized|http:NotFound {
    return
    {
        permissions:
         {
            "BROWSE_PROJECTS": 
                {
                    id: "10",
                    key: "BROWSE_PROJECTS",
                    name: "Browse Projects",
                    description: "Ability to browse projects and the issues within them.",
                    havePermission: true                   
                }
         }
    };
}


    // Mock response for `post rest/api/'3/role`
    resource function post rest/api/'3/role(@http:Payload CreateUpdateRoleRequestBean payload) returns ProjectRole|http:BadRequest|http:Unauthorized|http:Forbidden|http:Conflict {
        return
            {
                id: 101,
                name: payload.name,
                description: payload.description
            };
    }

     // New mock for `delete rest/api/'3/role/[int id]`
     resource function delete rest/api/'3/role/[int id](int? swap) returns http:NoContent|http:BadRequest|http:Unauthorized|http:Forbidden|http:NotFound|http:Conflict {
        return http:NO_CONTENT;
    }

    resource function post rest/api/'3/project(@http:Payload CreateProjectDetails payload) returns ProjectIdentifiers|http:BadRequest|http:Unauthorized|http:Forbidden {
        // Directly send a mock response without checking the payload
       return 
        {
            id: 10001,
            key: "EX",
            self: "http://example.com/project/10001"
        };
    }

    resource function get rest/api/'3/project/[string projectKeyOrId]/securitylevel() returns ProjectIssueSecurityLevels|http:NotFound {
        return 
        {
            levels: 
            [
                {
                    id: "10000",
                    name: "Default Security Level",
                    description: "This is the default security level."
                }
            ]
        };
    }

    resource function get rest/api/'3/applicationrole() returns ApplicationRole[]|http:Unauthorized|http:Forbidden {
       return [
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
    }

     // Mock endpoint to retrieve a specific ApplicationRole based on key
    resource function get rest/api/'3/applicationrole/[string 'key]() returns ApplicationRole|http:Unauthorized|http:Forbidden|http:NotFound {
        return 
        { 
            "key": "jira-software",
            "name": "Jira Software"
        }; 
    }

    // Mock endpoint for auditing records
    resource function get rest/api/'3/auditing/'record(string? filter, string? 'from, string? to, int:Signed32 offset = 0, int:Signed32 'limit = 1000) returns AuditRecords|ErrorCollectionUnauthorized|ErrorCollection{
        // Mock response with a sample record for testing
        return
        {
            "records": [
                {
                    "id": 1001,
                    "summary": "User logged in",
                    "created": "2023-10-25T12:34:56.000Z",
                    "category": "authentication"
                }
            ]
        };
    }

    resource function get rest/api/'3/classification\-levels(("PUBLISHED"|"ARCHIVED"|"DRAFT")[]? status, "rank"|"-rank"|"+rank"? orderBy) returns DataClassificationLevelsBean|http:Unauthorized {
        // Mock response mimicking a successful response with `classifications` key
     return 
        {
            "classifications": []
        };
    }

    resource function get rest/api/'3/dashboard("my"|"favourite"? filter, int:Signed32 startAt = 0, int:Signed32 maxResults = 20) returns PageOfDashboards|ErrorCollection|ErrorCollectionUnauthorized {
        // Mock response mimicking the structure of PageOfDashboards
        return 
        {
            "dashboards": []
        };
    }

    resource function post rest/api/'3/dashboard(@http:Payload DashboardDetails payload, boolean extendAdminPermissions = false) returns Dashboard|ErrorCollection|ErrorCollectionUnauthorized {
        // Mock response body mimicking the actual API response
       return 
        {
            "name": "Auditors dashboard",
            "id":"10001",
            "description": "A dashboard to help auditors identify sample of issues to check.",
            "sharePermissions": [],
            "editPermissions": []
        };
    }

    resource function get rest/api/'3/filter/defaultShareScope() returns DefaultShareScope|http:Unauthorized {
        // Mock response with a default share scope
        return 
        {
            "scope": "GLOBAL"
        };
    }

    resource function put rest/api/'3/filter/defaultShareScope(@http:Payload DefaultShareScope payload) returns DefaultShareScope|http:BadRequest|http:Unauthorized {

        // Mock response, echoing the request scope value
        return 
        {
            "scope":"AUTHENTICATED"
        };

    }

    resource function get rest/api/'3/filter/favourite(string? expand) returns Filter[]|http:Unauthorized {
        // Mock response with an array of Filter objects
      return 
        [
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
    }

    resource function get rest/api/'3/filter/my(string? expand, boolean includeFavourites = false) returns Filter[]|http:Unauthorized {
        // Mock response with an array of Filter objects
       return [
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
    }

    resource function post rest/api/'3/group(@http:Payload AddGroupBean payload) returns Group|http:BadRequest|http:Unauthorized|http:Forbidden {
            return 
            {
                "name": "first group",
                "groupId": "12345",
                "self": "http://localhost:9090/rest/api/3/group?groupId=12345"
            };
    }

    resource function delete rest/api/'3/group(string? groupname, string? groupId, string? swapGroup, string? swapGroupId) returns http:Ok|http:BadRequest|http:Unauthorized|http:Forbidden|http:NotFound {
        http:Ok okResponse = { };
        return okResponse;
    }

    resource function get rest/api/'3/fieldconfiguration(int[]? id, int startAt = 0, int:Signed32 maxResults = 50, boolean isDefault = false, string query = "") returns PageBeanFieldConfigurationDetails|http:Unauthorized|http:Forbidden {
        // Create a mock response
        PageBeanFieldConfigurationDetails mockResponse = 
        {
            "startAt": 0,
            "maxResults": 50,
            "total": 10  // Total field configurations, set to >0 for testing
        };
        return mockResponse;
    }

    resource function get rest/api/'3/'field() returns FieldDetails[]|http:Unauthorized {
        // Create a mock response
        FieldDetails[] mockResponse = 
        [
            {
                "id": "customfield_10000",
                "name": "Story Points",
                "custom": true,
                "orderable": true,
                "navigable": true,
                "searchable": true,
                "schema": 
                {
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
                "schema": 
                {
                    "type": "string",
                    "system": "summary"
                }
            }
        ];
        // Send the mock response
        return mockResponse;
    }
}


