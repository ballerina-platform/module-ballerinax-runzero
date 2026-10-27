# Examples

The `ballerinax/runzero` connector provides practical examples illustrating usage in various scenarios.

1. [Site asset inventory](./site_asset_inventory/site_asset_inventory.md) - List the live assets discovered in a site.
2. [Explorer task monitoring](./explorer_task_monitoring/explorer_task_monitoring.md) - Check explorer connectivity and review tasks by status.

## Prerequisites

Create a `Config.toml` file in the example directory with a runZero organization API key (starts with `OT`), along with any other values the example documents. Both examples call organization operations, so an export token (`ET`) does not work:

```toml
apiToken = "<Organization API key>"
```

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
