# Sales tax table update

This example reviews the sales tax table of an eBay seller account for a country and, when enabled, sets the tax rate of one jurisdiction and reads the entry back to confirm the change.

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
countryCode = "<US or CA, e.g. US>"
jurisdictionId = "<sales-tax-jurisdiction-id, e.g. AS>"
salesTaxPercentage = "<tax-percentage, e.g. 7.5>"
# shippingAndHandlingTaxed = false
applyChanges = false
```

Sales tax tables are available only for `US` and `CA`. For `US`, the only supported jurisdictions are the territories `AS` (American Samoa), `GU` (Guam), `MP` (Northern Mariana Islands), `PW` (Palau) and `VI` (US Virgin Islands); eBay collects sales tax for the states itself.

When the jurisdiction already has an entry, the example keeps its `shippingAndHandlingTaxed` setting unless you set one. To create a new entry, set `shippingAndHandlingTaxed` explicitly.

Updating the table changes the seller account, so the example only writes the entry when `applyChanges` is `true`. Otherwise it only prints the current table.

## Run the example

Execute the following command to run the example:

```bash
bal run
```
