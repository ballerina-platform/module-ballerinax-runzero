## Overview

[runZero](https://www.runzero.com/) is a cyber asset attack surface management platform that discovers and inventories the assets on a network. The runZero connector lets Ballerina applications work with the runZero REST API: manage organizations, sites, explorers and scan tasks, query discovered assets, services and vulnerabilities, export inventory data, and administer account users, groups, credentials and API keys.

This connector supports version 4.0.251021.0 of the runZero API.

### Key features

- Query and manage discovered assets, services, wireless networks, software and vulnerabilities
- Create and update sites, then launch scans, traffic sampling and data imports
- Monitor explorers, hosted zones and scan tasks
- Export inventory data in JSON, JSON Lines and CSV formats
- Administer account organizations, users, groups, SSO mappings, credentials and API keys

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

1. [Site asset inventory](../examples/site_asset_inventory/site_asset_inventory.md) - List the live assets discovered in a site.
2. [Explorer task monitoring](../examples/explorer_task_monitoring/explorer_task_monitoring.md) - Check explorer connectivity and review tasks by status.
