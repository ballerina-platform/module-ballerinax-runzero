# Ballerina runZero connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-runzero/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-runzero/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-runzero.svg)](https://github.com/ballerina-platform/module-ballerinax-runzero/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/runzero.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Frunzero)

## Overview

[runZero](https://www.runzero.com/) is a cyber asset attack surface management platform that discovers and inventories the assets on a network. The runZero connector lets Ballerina applications work with the runZero REST API: manage organizations, sites, explorers and scan tasks, query discovered assets, services and vulnerabilities, export inventory data, and administer account users, groups, credentials and API keys.

This connector supports version 4.0.251021.0 of the runZero API.


## Setup guide

To use the runZero connector, you need a runZero account and an API token.

1. Sign in to the runZero console at [console.runzero.com](https://console.runzero.com/).

2. Open the API keys page of your account or organization settings and create a new API key. Account keys start with `CT`, organization keys start with `OT` and export tokens start with `ET`.

   > **Note:** Organization operations such as `getSites()` need an organization key (`OT`), which is scoped to one organization, or an account key (`CT`) or OAuth client, which can select the organization with the `_oid` query parameter. Export tokens (`ET`) work only with the export operations, and account operations need an account key or an OAuth client.

3. Copy the generated token and store it securely. It is passed to the connector as a bearer token.

4. Alternatively, create an API client in the account settings and use its client ID and client secret with the OAuth 2.0 client credentials grant. The token endpoint is `https://console.runzero.com/api/v1.0/account/api/token`.

## Quickstart

To use the `runzero` connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/runzero;
```

### Step 2: Instantiate a new connector

Create a `Config.toml` file and configure the API token:

```toml
token = "<API token>"
```

Then create a client in the `.bal` file:

```ballerina
configurable string token = ?;

final runzero:Client runzeroClient = check new ({auth: {token}});
```

### Step 3: Invoke the connector operation

Use the client to list the sites of your organization:

```ballerina
public function main() returns error? {
    runzero:Site[] _ = check runzeroClient->getSites();
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `runZero` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-runzero/tree/main/examples/), covering the following use cases:

1. [Site asset inventory](examples/site_asset_inventory/site_asset_inventory.md) - List the live assets discovered in a site.
2. [Explorer task monitoring](examples/explorer_task_monitoring/explorer_task_monitoring.md) - Check explorer connectivity and review tasks by status.

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

* For more information go to the [`runzero` package](https://central.ballerina.io/ballerinax/runzero/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
