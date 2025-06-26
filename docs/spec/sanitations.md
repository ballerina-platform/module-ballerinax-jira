_Author_:  @lasithLRI \
_Created_: 2025/06/20 \
_Updated_: 2025/06/20 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Jira. 
The OpenAPI specification is obtained from [source](https://developer.atlassian.com/cloud/jira/platform/swagger-v3.v3.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. type keyword not escaping
    
    Originl: in types.bal ConnectCustomFieldValue record. 
        @jsondata:Name {value: "_type"}
        "StringIssueField"|"NumberIssueField"|"RichTextIssueField"|"SingleSelectIssueField"|"MultiSelectIssueField"|"TextIssueField" type;
    
    Updated:
        @jsondata:Name {value: "_type"}
        "StringIssueField"|"NumberIssueField"|"RichTextIssueField"|"SingleSelectIssueField"|"MultiSelectIssueField"|"TextIssueField" 'type;
    
    Reason: The "type" keyword needs to be escaped to compile correctly. However, in the generated code, this keyword is not escaped in this line.

2. When aligning the flattened OpenAPI specification, the common segments of the resource paths are expected to be moved to the serviceUrl. However, only part of the common path is being moved, resulting in inconsistent or incomplete serviceUrl values.

    Original : in Client.bal,
        serviceUrl:
             public isolated function init(ConnectionConfig config, string serviceUrl = "https://your-domain.atlassian.net/rest")

        sample resource path:
            resource isolated function get api/'3/myself(map<string|string[]> headers = {}, *GetCurrentUserQueries queries) returns User|error 

    Updated:
        serviceUrl:
             public isolated function init(ConnectionConfig config, string serviceUrl = "https://your-domain.atlassian.net/rest/api/'3/")

        sample resource path:
            resource isolated function get myself(map<string|string[]> headers = {}, *GetCurrentUserQueries queries) returns User|error 

Reason: To generate a client using the aligned YAML file. During the alignment of the flattened OpenAPI specification, the common segments of the resource paths are expected to be moved to the serviceUrl, while the unique segments should remain within the resources. However, only part of the common path is being moved, resulting in inconsistent or incomplete serviceUrl values

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
$ bal openapi -i docs/spec/openapi.yaml --mode client --license docs/license.txt -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
