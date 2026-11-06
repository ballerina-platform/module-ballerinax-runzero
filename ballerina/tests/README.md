# Tests

The test suite exercises 25 representative operations of the connector: reading and managing sites, assets, services, explorers, tasks, hosted zones, account organizations, users, API keys and license details. Every test calls the connector client and asserts on the shape of the response.

The tests run against a mock server (`tests/mock_service.bal`) by default. To run them against a real runZero console, set the following environment variables:

```bash
export IS_LIVE_SERVER=true
export RUNZERO_API_TOKEN=<API token>
```

Tests that create, update or delete data run only against the mock server.

## Running Tests

```bash
bal test
```

To run only the tests that are safe to run against a live console:

```bash
bal test --groups live_tests
```
