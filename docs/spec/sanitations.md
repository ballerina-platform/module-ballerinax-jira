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

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
$ bal openapi flatten -i docs/spec/openapi.yaml -o docs/spec
$ bal openapi align -i docs/spec/flattened_openapi.yaml -o docs/spec
```
Note: The license year is hardcoded to 2024, change if necessary.
