# Running Tests

## Prerequisites

You need an eBay seller account and an OAuth access token granted the `https://api.ebay.com/oauth/api_scope/sell.account` scope to run the tests against the live eBay Account API. The mock tests need no credentials.

## Test environments

There are two test environments for running the connector tests. The default environment is the mock server and the other is the live eBay Account API.

| Test Groups  | Environment                                              |
| ------------ | -------------------------------------------------------- |
| mock_tests   | Mock server for the eBay Account API (default)           |
| live_tests   | eBay Account API (production)                            |

## Running the tests

1. To run the tests against the mock server, execute:

    ```bash
    bal test --groups mock_tests
    ```

2. To run the tests against the live API, set the following environment variables and execute the live test group:

    ```bash
    export IS_LIVE_SERVER=true
    export EBAY_ACCESS_TOKEN=<access-token>
    bal test --groups live_tests
    ```

The live group only runs the read-only operations that do not depend on mock fixtures. Operations that create, update or delete policies and sales tax entries run against the mock server only.
