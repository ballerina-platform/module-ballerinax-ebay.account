# Ballerina eBay Account connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-ebay.account/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.account/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-ebay.account.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.account/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/ebay.account.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Febay.account)

## Overview

[eBay](https://www.ebay.com/) is a global online marketplace where businesses and individuals buy and sell goods. The [eBay Account API](https://developer.ebay.com/api-docs/sell/account/overview.html) lets sellers configure their eBay seller accounts: manage business policies and custom policies, opt in to and out of seller programs, maintain sales tax tables, and read account information such as privileges, subscriptions and KYC status.

The eBay Account connector lets Ballerina applications call these operations with typed requests and responses. It supports version 1 of the eBay Account API.

## Setup guide

To use the eBay Account connector, you need an eBay developer account and an application keyset. If you do not have a developer account, you can [sign up for one](https://developer.ebay.com/signin).

### Step 1: Create an application keyset

1. Sign in to the [eBay Developer Program](https://developer.ebay.com/my/keys) and open **Application Keys**.

2. Create a keyset for the **Production** environment and note down the **App ID (Client ID)** and **Cert ID (Client Secret)**.

### Step 2: Configure the OAuth settings

1. In the keyset's **User Tokens** section, create an **eBay Redirect URL (RuName)** for your application and set its accept and decline URLs.

2. Make sure the application is granted the following scopes:
   * `https://api.ebay.com/oauth/api_scope/sell.account`
   * `https://api.ebay.com/oauth/api_scope/sell.account.readonly`

### Step 3: Get the user authorization

1. Open the **Get a User Token Here** link for your keyset and sign in as the seller. The consent flow redirects to your accept URL with an authorization code.

2. Exchange the authorization code for tokens:

```bash
curl -X POST https://api.ebay.com/identity/v1/oauth2/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -H "Authorization: Basic $(echo -n 'CLIENT_ID:CLIENT_SECRET' | base64)" \
  -d "grant_type=authorization_code&code=AUTHORIZATION_CODE&redirect_uri=YOUR_RUNAME"
```

This returns an `access_token` and a `refresh_token`. Use the refresh token to configure the connector so that it can renew the access token automatically.

Replace:
* `CLIENT_ID` with your App ID
* `CLIENT_SECRET` with your Cert ID
* `AUTHORIZATION_CODE` with the URL-decoded code received on the redirect
* `YOUR_RUNAME` with your eBay Redirect URL name

## Quickstart

To use the eBay Account connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

Import the `ebay.account` module.

```ballerina
import ballerinax/ebay.account;
```

### Step 2: Instantiate a new connector

1. Create a `Config.toml` file and configure the credentials obtained in the steps above:

```toml
clientId = "<Client ID>"
clientSecret = "<Client Secret>"
refreshToken = "<Refresh Token>"
refreshUrl = "https://api.ebay.com/identity/v1/oauth2/token"
```

2. Create an `account:ConnectionConfig` with the OAuth 2.0 refresh-token credentials and initialize the connector with it.

```ballerina
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;
configurable string refreshUrl = ?;

final account:Client ebay = check new ({
    auth: {
        clientId,
        clientSecret,
        refreshToken,
        refreshUrl
    }
});
```

### Step 3: Invoke the connector operation

Now, utilize the available connector operations.

#### List the seller's fulfillment policies

```ballerina
public function main() returns error? {
    account:FulfillmentPolicyResponse _ = check ebay->getFulfillmentPolicies(marketplaceId = "EBAY_US");
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The eBay Account connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-ebay.account/tree/main/examples/), covering the following use cases:

1. [Seller policy setup](https://github.com/ballerina-platform/module-ballerinax-ebay.account/tree/main/examples/seller_policy_setup) - List the fulfillment, payment and return policies of a marketplace and create any that are missing.

2. [Sales tax table update](https://github.com/ballerina-platform/module-ballerinax-ebay.account/tree/main/examples/sales_tax_table_update) - Review the sales tax table of a country, set the rate of one jurisdiction and read it back.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`ebay.account` package](https://central.ballerina.io/ballerinax/ebay.account/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
