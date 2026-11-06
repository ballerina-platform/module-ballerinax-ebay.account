# Seller policy setup

This example lists the fulfillment, payment and return business policies of an eBay seller account for a marketplace and, when enabled, creates a policy of each kind that does not exist yet.

## Prerequisites

### 1. Set up an eBay application

Follow the [Setup guide](https://github.com/ballerina-platform/module-ballerinax-ebay.account/blob/main/ballerina/README.md#setup-guide) to obtain a client ID, client secret and refresh token. The refresh token must be granted the `https://api.ebay.com/oauth/api_scope/sell.account` scope.

### 2. Configuration

Create a `Config.toml` file in this example's directory with the following content:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
refreshUrl = "<oauth-token-url>"
marketplaceId = "<marketplace-id, e.g. EBAY_US>"
policyNamePrefix = "<prefix-for-the-policy-names>"
createPolicies = false
```

Creating policies changes the seller account, so the example only creates them when `createPolicies` is `true`. Otherwise it only lists the existing policies. Listing works for any marketplace, but creation is limited to `EBAY_US`, because the fulfillment policy ships with the USPS Priority Mail service.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
