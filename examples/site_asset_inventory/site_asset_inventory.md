# Site asset inventory

This example finds a runZero site by name, lists the assets in that site that are currently alive, and prints the details of the first few of them. It uses the `getSites`, `getAssets` and `getAsset` operations.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A runZero API token
- Create a `Config.toml` in this directory:

  ```toml
  apiToken = "<API token>"
  siteName = "<Site name>"
  maxAssets = 10
  ```

## Run the example

```bash
bal run
```
