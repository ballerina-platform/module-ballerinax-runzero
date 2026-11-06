# Explorer task monitoring

This example reports which runZero explorers are connected and lists the tasks that are in a given status together with their details. It uses the `getExplorers`, `getTasks` and `getTask` operations.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- A runZero API token
- Create a `Config.toml` in this directory:

  ```toml
  apiToken = "<API token>"
  taskStatus = "active"
  ```

## Run the example

```bash
bal run
```
