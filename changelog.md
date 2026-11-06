# Changelog

All notable changes to this project are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- The initial runZero connector, a `Client` with 181 remote methods for the runZero REST API, covering organizations, sites, assets, services, wireless networks, tasks and scans, agents and explorers, data import and export, account management (users, groups, keys, credentials, scan templates, custom integrations) and the ServiceNow, Splunk and Cisco exports.
- Authentication through `ConnectionConfig.auth`, with either a bearer token (`http:BearerTokenConfig`) or OAuth 2.0 client credentials (`OAuth2ClientCredentialsGrantConfig`, whose `tokenUrl` defaults to `https://console.runzero.com/api/v1.0/account/api/token`).
- A default `serviceUrl` of `https://console.runzero.com/api/v1.0`.
