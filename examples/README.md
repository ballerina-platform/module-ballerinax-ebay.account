# Examples

The `ballerinax/ebay.account` connector provides practical examples illustrating usage in various scenarios.

1. **[Seller policy setup](https://github.com/ballerina-platform/module-ballerinax-ebay.account/tree/main/examples/seller_policy_setup)** - List the fulfillment, payment and return policies of a marketplace and create any that are missing.

2. **[Sales tax table update](https://github.com/ballerina-platform/module-ballerinax-ebay.account/tree/main/examples/sales_tax_table_update)** - Review the sales tax table of a country, set the rate of one jurisdiction and read it back.

## Prerequisites

1. Generate eBay credentials to authenticate the connector as described in the [Setup guide](https://central.ballerina.io/ballerinax/ebay.account/latest#setup-guide).

2. For each example, create a `Config.toml` file with the related configuration. Here's an example of how your Config.toml file should look:

```toml
clientId = "<client-id>"
clientSecret = "<client-secret>"
refreshToken = "<refresh-token>"
refreshUrl = "<oauth-token-url>"
```

Each example lists the additional values it needs in its own README.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
