
// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.


import ballerina/constraint;
import ballerina/http;

listener http:Listener ep0 = new (9090);

const string ORG_ID = "e77602e0-3fb8-4734-aef9-fbc6fdcb0fa8";
const string SITE_ID = "e0d8cdd4-1a3f-4b5c-9a43-5a1f0e0f2c11";
const string EXPLORER_ID = "6f9a1c2e-8b7d-4e55-b0f1-2c3d4e5f6a7b";
const string ASSET_ID = "9c1f2b3a-4d5e-4f60-8a71-b2c3d4e5f607";
const string SERVICE_ID = "3b2a1c0d-9e8f-4a7b-8c6d-5e4f3a2b1c0d";
const string TASK_ID = "0a1b2c3d-4e5f-4a6b-8c7d-9e0f1a2b3c4d";

final Site mockSite = {
    id: SITE_ID,
    name: "Primary",
    description: "Headquarters network",
    scope: "10.0.0.0/8",
    excludes: "10.255.0.0/16",
    subnets: {"10.0.1.0/24": {"name": "Servers"}},
    createdAt: 1700000000,
    updatedAt: 1700003600
};

final Organization mockOrganization = {
    id: ORG_ID,
    name: "Acme Corp",
    description: "Acme production organization",
    clientId: "b2d3c4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e",
    project: false,
    inactive: false,
    assetCount: 1250,
    serviceCount: 8420,
    createdAt: 1690000000,
    updatedAt: 1700000000
};

final Agent mockExplorer = {
    id: EXPLORER_ID,
    name: "explorer-hq-01",
    os: "linux",
    arch: "amd64",
    version: "4.0.251021.0",
    connected: true,
    inactive: false,
    internalIp: "10.0.1.15",
    externalIp: "203.0.113.25",
    siteId: SITE_ID,
    organizationId: ORG_ID,
    createdAt: 1690000000,
    updatedAt: 1700000000,
    lastCheckin: 1700003000
};

final Asset mockAsset = {
    id: ASSET_ID,
    addresses: ["10.0.1.20"],
    names: ["web-01.acme.test"],
    os: "Ubuntu Linux",
    osVersion: "22.04",
    'type: "Server",
    hw: "Dell PowerEdge",
    alive: true,
    macs: ["00:50:56:ab:cd:ef"],
    serviceCount: 4,
    siteId: SITE_ID,
    siteName: "Primary",
    organizationId: ORG_ID,
    tags: {"env": "prod"},
    firstSeen: 1690000000,
    lastSeen: 1700000000,
    createdAt: 1690000000,
    updatedAt: 1700000000
};

final Service mockService = {
    id: ASSET_ID,
    serviceId: SERVICE_ID,
    serviceAssetId: ASSET_ID,
    serviceAddress: "10.0.1.20",
    servicePort: "443",
    serviceTransport: "tcp",
    serviceProtocol: "https",
    serviceSummary: "nginx 1.24 web server",
    siteId: SITE_ID,
    organizationId: ORG_ID,
    serviceCreatedAt: 1690000000,
    serviceUpdatedAt: 1700000000
};

final Task mockTask = {
    id: TASK_ID,
    name: "Weekly scan",
    'type: "scan",
    status: "processed",
    description: "Scheduled network scan",
    siteId: SITE_ID,
    organizationId: ORG_ID,
    recur: true,
    recurFrequency: "week",
    createdAt: 1700000000,
    updatedAt: 1700003600,
    startTime: 1700001000
};

@http:ServiceConfig {treatNilableAsOptional: true}
service / on ep0 {
    # Remove an asset
    #
    # + oid - The current Organization
    # + assetId - UUID of the asset to remove
    # + return - empty response on success, or an error response
    resource function delete org/assets/[string assetId](@http:Query {name: "_oid"} string? oid) returns http:NoContent|ProblemUnauthorized|ProblemNotFound {
        if assetId != ASSET_ID {
            return notFound();
        }
        return http:NO_CONTENT;
    }

    # Remove a site and associated assets
    #
    # + oid - The current Organization
    # + siteId - UUID or name of the site to remove
    # + return - empty response on success, or an error response
    resource function delete org/sites/[string siteId](@http:Query {name: "_oid"} string? oid) returns http:NoContent|ProblemUnauthorized|ProblemNotFound {
        if !isKnownSite(siteId) {
            return notFound();
        }
        return http:NO_CONTENT;
    }

    # Get all active API keys
    #
    # + return - array of keys, or an error response
    resource function get account/keys() returns APIKey[]|ProblemUnauthorized {
        return [
            {
                id: "d1e2f3a4-b5c6-4d7e-8f90-a1b2c3d4e5f6",
                'type: "account",
                comment: "Integration key",
                createdBy: "admin@acme.test",
                clientId: "b2d3c4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e",
                counter: 12,
                usageToday: 3,
                usageLimit: 1000,
                inactive: false,
                createdAt: 1690000000,
                lastUsedAt: 1700000000
            }
        ];
    }

    # Get license details
    #
    # + return - license information, or an error response
    resource function get account/license() returns License|ProblemUnauthorized {
        return {
            id: "f0e1d2c3-b4a5-4968-8777-665544332211",
            name: "Acme Corp",
            licenseType: "enterprise",
            licenseMaxAssets: 5000,
            licenseLiveAssetCount: 1250,
            licenseProjectAssetCount: 0,
            licenseExpiration: 1900000000,
            createdAt: 1690000000,
            updatedAt: 1700000000
        };
    }

    # Get all organization details
    #
    # + search - an optional search string for filtering results
    # + return - array of organizations, or an error response
    resource function get account/orgs(string? search) returns Organization[]|ProblemUnauthorized {
        return [mockOrganization];
    }

    # Get all users
    #
    # + return - array of users, or an error response
    resource function get account/users() returns User[]|ProblemUnauthorized {
        return [
            {
                id: "7a8b9c0d-1e2f-4a3b-8c4d-5e6f7a8b9c0d",
                firstName: "Jane",
                lastName: "Doe",
                email: "jane.doe@acme.test",
                clientAdmin: true,
                mfaEnabled: true,
                createdAt: 1690000000,
                updatedAt: 1700000000
            }
        ];
    }

    # Returns a health check status (cloud and self-hosted)
    #
    # + return - health status and current version
    resource function get health() returns HealthCheckResponse {
        return {status: "ok", version: "4.0.251021.0"};
    }

    # Get organization details
    #
    # + oid - The current Organization
    # + return - organization details, or an error response
    resource function get org(@http:Query {name: "_oid"} string? oid) returns Organization|ProblemUnauthorized {
        return mockOrganization;
    }

    # Get all agents. Legacy path for /org/explorers
    #
    # + oid - The current Organization
    # + return - array of agents, or an error response
    resource function get org/agents(@http:Query {name: "_oid"} string? oid) returns Agent[]|ProblemUnauthorized {
        return [mockExplorer];
    }

    # Get details for a single agent. Legacy path for /org/explorers/{explorer_id}
    #
    # + oid - The current Organization
    # + agentId - UUID of the agent
    # + return - agent details, or an error response
    resource function get org/agents/[string agentId](@http:Query {name: "_oid"} string? oid) returns Agent|ProblemUnauthorized|ProblemNotFound {
        if agentId != EXPLORER_ID {
            return notFound();
        }
        return mockExplorer;
    }

    # Get all assets
    #
    # + oid - The current Organization
    # + search - A search query in runZero search query syntax
    # + fields - A list of fields to export, comma-separated
    # + return - array of assets, or an error response
    resource function get org/assets(@http:Query {name: "_oid"} string? oid, string? search, string? fields) returns Asset[]|ProblemUnauthorized {
        return [mockAsset];
    }

    # Get asset details
    #
    # + oid - The current Organization
    # + assetId - UUID of the asset to retrieve
    # + return - asset details, or an error response
    resource function get org/assets/[string assetId](@http:Query {name: "_oid"} string? oid) returns Asset|ProblemUnauthorized|ProblemNotFound {
        if assetId != ASSET_ID {
            return notFound();
        }
        return mockAsset;
    }

    # Get all explorers
    #
    # + oid - The current Organization
    # + return - array of explorers, or an error response
    resource function get org/explorers(@http:Query {name: "_oid"} string? oid) returns Explorer[]|ProblemUnauthorized {
        return [mockExplorer];
    }

    # Get details for a single explorer.
    #
    # + oid - The current Organization
    # + explorerId - UUID of the explorer
    # + return - explorer details, or an error response
    resource function get org/explorers/[string explorerId](@http:Query {name: "_oid"} string? oid) returns Explorer|ProblemUnauthorized|ProblemNotFound {
        if explorerId != EXPLORER_ID {
            return notFound();
        }
        return mockExplorer;
    }

    # Get all hosted zones
    #
    # + oid - The current Organization
    # + return - array of hosted zones, or an error response
    resource function get org/hosted\-zones(@http:Query {name: "_oid"} string? oid) returns HostedZone[]|ProblemUnauthorized {
        return [
            {
                id: "4c5d6e7f-8091-4a2b-b3c4-d5e6f7a8b9c0",
                name: "us-east-zone",
                enabled: true,
                explorersTotal: 3,
                explorersConcurrency: 6,
                tasksActive: 1,
                tasksWaiting: 0,
                organizationId: ORG_ID
            }
        ];
    }

    # Get all services
    #
    # + oid - The current Organization
    # + search - A search query in runZero search query syntax
    # + return - array of services, or an error response
    resource function get org/services(@http:Query {name: "_oid"} string? oid, string? search) returns Service[]|ProblemUnauthorized {
        return [mockService];
    }

    # Get service details
    #
    # + oid - The current Organization
    # + serviceId - UUID of the service to retrieve
    # + return - service details, or an error response
    resource function get org/services/[string serviceId](@http:Query {name: "_oid"} string? oid) returns Service|ProblemUnauthorized|ProblemNotFound {
        if serviceId != SERVICE_ID {
            return notFound();
        }
        return mockService;
    }

    # Get all sites
    #
    # + oid - The current Organization
    # + return - array of sites, or an error response
    resource function get org/sites(@http:Query {name: "_oid"} string? oid) returns Site[]|ProblemUnauthorized {
        return [mockSite];
    }

    # Get site details
    #
    # + oid - The current Organization
    # + siteId - UUID or name of the site to retrieve
    # + return - site details, or an error response
    resource function get org/sites/[string siteId](@http:Query {name: "_oid"} string? oid) returns Site|ProblemUnauthorized|ProblemNotFound {
        if !isKnownSite(siteId) {
            return notFound();
        }
        return mockSite;
    }

    # Get all tasks
    #
    # + oid - The current Organization
    # + status - an optional status filter
    # + search - A search query in runZero search query syntax
    # + return - array of tasks, or an error response
    resource function get org/tasks(@http:Query {name: "_oid"} string? oid, string? status, string? search) returns Task[]|ProblemUnauthorized {
        return [mockTask];
    }

    # Get task details
    #
    # + oid - The current Organization
    # + taskId - UUID of the task to retrieve
    # + return - task details, or an error response
    resource function get org/tasks/[string taskId](@http:Query {name: "_oid"} string? oid) returns Task|ProblemUnauthorized|ProblemNotFound {
        if taskId != TASK_ID {
            return notFound();
        }
        return mockTask;
    }

    # Update a site definition
    #
    # + oid - The current Organization
    # + siteId - UUID or name of the site to update
    # + payload - site object
    # + return - updated site details, or an error response
    resource function patch org/sites/[string siteId](@http:Query {name: "_oid"} string? oid, @http:Payload SiteOptions payload) returns Site|ProblemUnauthorized|ProblemNotFound {
        if !isKnownSite(siteId) {
            return notFound();
        }
        Site updated = mockSite.clone();
        updated.name = payload.name;
        string? description = payload.description;
        if description is string {
            updated.description = description;
        }
        string? scope = payload.scope;
        if scope is string {
            updated.scope = scope;
        }
        return updated;
    }

    # Create a new organization
    #
    # + payload - organization definition
    # + return - created organization details, or an error response
    resource function put account/orgs(@http:Payload OrgOptions payload) returns Organization|ProblemUnauthorized|ProblemNotFound {
        Organization created = mockOrganization.clone();
        created.name = payload.name ?: "New Organization";
        created.id = "a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d";
        return created;
    }

    # Create a new user account
    #
    # + payload - user parameters
    # + return - created user details, or an error response
    resource function put account/users(@http:Payload UserOptions payload) returns User|ProblemUnauthorized|ProblemNotFound {
        return {
            id: "2b3c4d5e-6f70-4819-a2b3-c4d5e6f70819",
            firstName: payload.firstName,
            lastName: payload.lastName,
            email: payload.email,
            clientAdmin: false,
            mfaEnabled: false,
            createdAt: 1700000000,
            updatedAt: 1700000000
        };
    }

    # Create a new site
    #
    # + oid - The current Organization
    # + payload - site definition
    # + return - created site details, or an error response
    resource function put org/sites(@http:Query {name: "_oid"} string? oid, @http:Payload SiteOptions payload) returns Site|ProblemUnauthorized|ProblemNotFound {
        Site created = mockSite.clone();
        created.id = "b7c8d9e0-f1a2-4b3c-8d4e-5f6a7b8c9d0e";
        created.name = payload.name;
        created.description = payload.description;
        created.scope = payload.scope;
        return created;
    }
}

function isKnownSite(string siteId) returns boolean => siteId == SITE_ID || siteId == mockSite.name;

function notFound() returns ProblemNotFound => {body: {status: 404, title: "Not Found", detail: "No resource exists with the given ID"}};

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ProblemNotFound record {|
    *http:NotFound;
    Problem body;
|};

public type ProblemUnauthorized record {|
    *http:Unauthorized;
    Problem body;
|};

# RFC7807 Problem JSON object from https://opensource.zalando.com/restful-api-guidelines/models/problem-1.0.1.yaml without the standard 'type' and 'instance' fields
public type Problem record {
    # A human readable explanation specific to this occurrence of the problem that is helpful to locate the problem and give advice on how to proceed. Written in English and readable for engineers, usually not suited for non technical stakeholders and not localized
    string detail?;
    # A short summary of the problem type. Written in English and readable for engineers, usually not suited for non technical stakeholders and not localized
    string title?;
    # The HTTP status code generated by the origin server for this occurrence of the problem
    @constraint:Int {minValue: 100, maxValueExclusive: 600}
    int:Signed32 status?;
};
