_Author_: @AnsarMahir \
_Created_: 10/25/2024 \
_Updated_: 10/25/2024 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Jira. 
The OpenAPI specification is obtained from ([Atlassian official website](https://developer.atlassian.com/cloud/jira/platform/swagger-v3.v3.json)).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

[//]: # (TODO: Add sanitation details)
1. Removed the request body and the request body schema of the operation getIssueLimitReport (GET) ( /rest/api/3/issue/limit/report)
2. Removed the request body of the operation searchAndReconsileIssuesUsingJql (GET) ( /rest/api/3/search/jql)
3. Removed depricated operation getGroup (GET) (/rest/api/3/group). Available through (GET) (/rest/api/3/group/member)
4. Removed depricated operation getContextsForFieldDeprecated and PageBeanContext schema (GET) (/rest/api/3/field/{fieldId}/contexts)
5. Removed depricated operation getProrities (GET) (/rest/api/3/priority
)
6. Removed depricated operation createPriority and CreatePriorityDetails and PriorityId schema (POST) (/rest/api/3/priority
)
7. Removed depricated operation searchPriorities and PageBeanPriority schema (GET) (/rest/api/3/priority/search)
8. Removed depricated operation updatePriority and UpdatePriorityDetails schema (PUT) (/rest/api/3/priority/{id})
9. Removed depricated operation getResolution (GET) (/rest/api/3/resolution) 
10. Removed depricated operation getCreateIssueMetadata and IssueCreateMetadata schema (GET) (/rest/api/3/issue/createmeta) 
11. Removed depricated operation deleteLocale (DELETE) (/rest/api/3/mypreferences/locale)
12. Removed depricated operation setLocale (PUT) (/rest/api/3/mypreferences/locale) 
13. Removed depricated operation deleteVersion (DELETE) (/rest/api/3/version/{id})  
14. Removed depricated operation getAllProjects (GET) (/rest/api/3/project)  
15. Removed depricated operation createWorkflow and WorkflowIDs, CreateWorkflowDetails schema (POST) (/rest/api/3/workflow)
16. Removed depricated operation getAllWorkflows and DeprecatedWorkflow schema (GET) (/rest/api/3/workflow) 
17. Removed depricated operation getAllWorkflows and DeprecatedWorkflow schema (GET) (/rest/api/3/workflow) 

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/openapi.yaml  --mode client -o ballerina
```
Note: The license year is hardcoded to 2024, change if necessary.
