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
}
