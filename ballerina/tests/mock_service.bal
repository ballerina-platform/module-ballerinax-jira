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
                    "id": "1001",
                    "summary": "User logged in",
                    "created": "2023-10-25T12:34:56.000Z",
                    "category": "authentication",
                    "eventSource": "Jira",
                    "eventType": "user_logged_in"
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

}
