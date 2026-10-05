_Author_:  @DimuthuMadushan \
_Created_: 2026/10/05 \
_Updated_: 2026/10/05 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from eBay Account.
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/ebay/account/v1/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Added a `summary` to all 37 operations. The original specification has none, and the summaries become the method documentation of the generated client. Each summary is unique and starts with a verb that matches the HTTP method (for example `List fulfillment policies` for `GET /fulfillment_policy`, `Create a fulfillment policy` for `POST /fulfillment_policy`).

2. Replaced the generic success response descriptions (`OK`, `Created`, `No Content` and similar) on operations that return a body with a description of what is returned, and filled one other missing description.

3. Replaced the templated server URL `https://api.ebay.com{basePath}` (with a `basePath` variable defaulting to `/sell/account/v1`) with the plain URL `https://api.ebay.com/sell/account/v1`, so that the generated client's default `serviceUrl` matches the specification.

4. Replaced the `Success` descriptions of the 200 responses of `optInToProgram`, `optOutOfProgram` and `bulkCreateOrReplaceSalesTax` with descriptions of the returned content.

5. Kept the operation IDs and schema names of the original specification as they are, because all of them are already concise, unique and within the 37 character limit. They are recorded unchanged in `ai-mappings.json` so that a regeneration reproduces the same public surface.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --license docs/license.txt -o ballerina --client-methods remote
```

Note: The license year is hardcoded to 2026, change if necessary.
