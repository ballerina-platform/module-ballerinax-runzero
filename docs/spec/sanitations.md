_Author_:  @DimuthuMadushan \
_Created_: 2026/10/26 \
_Updated_: 2026/10/26 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from runZero.
The OpenAPI specification is obtained from [openapi.yaml](https://github.com/wso2/api-specs/blob/main/openapi/runzero/runzero/4.0.251021.0/openapi.yaml).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

1. Rewrote `info.description` as a short plain-text summary of the API, which becomes the `Client` class description. The change is made in the original `docs/spec/openapi.yaml`.

   **Original**:
   ```
   runZero API. API use is rate limited, you can make as many calls per day as you have licensed assets.
   ```

   **Updated**:
   ```
   Manage runZero network asset discovery and inventory, including organizations, sites, assets, scans, tasks, users and integrations, through the runZero REST API.
   ```

2. Made seven operation summaries unique, because they were shared by two operations each. The change is made in the original `docs/spec/openapi.yaml`.

   | Operation | Original summary | Updated summary |
   |---|---|---|
   | `GET /account/orgs/{org_id}` | Get organization details | Get account organization details |
   | `PATCH /account/orgs/{org_id}` | Update organization details | Update account organization details |
   | `GET /account/custom-integrations` | Get all custom integrations | Get all account custom integrations |
   | `GET /account/custom-integrations/{customIntegrationId}` | Get single custom integration | Get single account custom integration |
   | `DELETE /account/orgs/{org_id}/exportToken` | Removes the export token from the specified organization | Removes the legacy export token from the specified organization |
   | `PATCH /account/orgs/{org_id}/exportToken/rotate` | Rotates an organization export token and returns the updated token | Rotates the legacy organization export token and returns the updated token |
   | `GET /export/org/assets.servicegraph.json` | Exports the asset inventory as JSON | Exports the asset inventory as ServiceGraph JSON |

3. Added descriptions to 14 request bodies and to 83 properties of the `HostedZone`, `HealthCheckResponse`, `SampleOptions`, `ScanOptions`, `Agent`, `TaskBase`, `NewAssetImport.importTask` and `ComponentVersion` schemas, so that the generated package has no `undocumented field` warnings. The changes are made in the original `docs/spec/openapi.yaml` with `tooling/apply_descriptions.py`, from the decisions file `docs/spec/description-decisions.json`.

4. Renamed the operations `deleteAccountOrganizationExportTokenDeprecated` and `rotateAccountOrganizationExportTokenDeprecated`, whose names were longer than 37 characters, to `deleteAccountOrgExportTokenLegacy` and `rotateAccountOrgExportTokenLegacy`. The names are persisted in `docs/spec/ai-mappings.json`.

5. Renamed the generated `InlineResponse*` schemas and the inline one-of schemas that the flatten step produced to descriptive names, persisted in `docs/spec/ai-mappings.json`.

   | Original | Updated |
   |---|---|
   | `InlineResponse200`, `InlineResponse2001`, `InlineResponse2002`, `InlineResponse2003`, `InlineResponse2004`, `InlineResponse2006` | `ExportAssetsResponse`, `ExportServicesResponse`, `ExportWirelessResponse`, `ExportSoftwareResponse`, `ExportVulnerabilitiesResponse`, `ExportEventsResponse` |
   | `InlineResponse200OneOf1` and the matching `...OneOf1` schemas | `AssetList`, `ServiceList`, `WirelessList`, `SoftwareList`, `VulnerabilityList`, `EventList` |
   | `InlineResponse200InlineResponse200OneOf12` and the matching `...OneOf12` schemas | `AssetsPage`, `ServicesPage`, `WirelessPage`, `SoftwarePage`, `VulnerabilitiesPage`, `EventsPage` |
   | `InlineResponse2005` | `UpdatedAssetCountResponse` |
   | `InlineResponseMap200` | `AssetMetricsResponse` |
   | `AddressesOneOf1`, `AddressesExtraOneOf1`, `SanIpAddressesOneOf1` and the other IPv4/IPv6 format-only one-of schemas | `AddressIpv4`, `AddressExtraIpv4`, `SanIpv4Address`, `AddressIpv6`, `AddressExtraIpv6`, `SanIpv6Address` and their `Alt` variants |

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --client-methods remote --license docs/license.txt
```
Note: The license year is hardcoded to 2024, change if necessary.
