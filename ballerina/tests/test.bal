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


import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://console.runzero.com/api/v1.0" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("RUNZERO_API_TOKEN") : "test_token";

final Client runzero = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetHealthCheck() returns error? {
    HealthCheckResponse response = check runzero->getHealthCheck();
    test:assertTrue(response.status.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetOrganization() returns error? {
    Organization response = check runzero->getOrganization();
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSites() returns error? {
    Site[] response = check runzero->getSites();
    if !isLiveServer {
        test:assertTrue(response.length() > 0);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSite() returns error? {
    Site[] sites = check runzero->getSites();
    if sites.length() == 0 {
        return;
    }
    Site response = check runzero->getSite(sites[0].id);
    test:assertEquals(response.id, sites[0].id);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateSite() returns error? {
    if isLiveServer {
        return;
    }
    Site response = check runzero->createSite({name: "Branch Office", scope: "10.20.0.0/16"});
    test:assertEquals(response.name, "Branch Office");
}

@test:Config {groups: ["mock_tests"]}
isolated function testUpdateSite() returns error? {
    if isLiveServer {
        return;
    }
    Site response = check runzero->updateSite(SITE_ID, {name: "Renamed Site"});
    test:assertEquals(response.name, "Renamed Site");
    test:assertEquals(response?.description, "Headquarters network");
    test:assertEquals(response?.scope, "10.0.0.0/8");
}

@test:Config {groups: ["mock_tests"]}
isolated function testRemoveSite() returns error? {
    if isLiveServer {
        return;
    }
    check runzero->removeSite(SITE_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAssets() returns error? {
    Asset[] response = check runzero->getAssets();
    if !isLiveServer {
        test:assertTrue(response.length() > 0);
    }
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAsset() returns error? {
    Asset[] assets = check runzero->getAssets();
    if assets.length() == 0 {
        return;
    }
    Asset response = check runzero->getAsset(assets[0].id);
    test:assertEquals(response.id, assets[0].id);
}

@test:Config {groups: ["mock_tests"]}
isolated function testRemoveAsset() returns error? {
    if isLiveServer {
        return;
    }
    check runzero->removeAsset(ASSET_ID);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAgents() returns error? {
    Agent[] response = check runzero->getAgents();
    test:assertTrue(response.length() >= 0);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetAgent() returns error? {
    if isLiveServer {
        return;
    }
    Agent response = check runzero->getAgent(EXPLORER_ID);
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetExplorers() returns error? {
    Explorer[] response = check runzero->getExplorers();
    test:assertTrue(response.length() >= 0);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetExplorer() returns error? {
    if isLiveServer {
        return;
    }
    Explorer response = check runzero->getExplorer(EXPLORER_ID);
    test:assertTrue(response.id.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetTasks() returns error? {
    Task[] response = check runzero->getTasks();
    test:assertTrue(response.length() >= 0);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetTask() returns error? {
    if isLiveServer {
        return;
    }
    Task response = check runzero->getTask(TASK_ID);
    test:assertTrue(response?.id !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetServices() returns error? {
    Service[] response = check runzero->getServices();
    test:assertTrue(response.length() >= 0);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetService() returns error? {
    if isLiveServer {
        return;
    }
    Service response = check runzero->getService(SERVICE_ID);
    test:assertTrue(response.serviceId.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAccountOrganizations() returns error? {
    Organization[] response = check runzero->getAccountOrganizations();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateAccountOrganization() returns error? {
    if isLiveServer {
        return;
    }
    Organization response = check runzero->createAccountOrganization({name: "Subsidiary"});
    test:assertEquals(response.name, "Subsidiary");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAccountUsers() returns error? {
    User[] response = check runzero->getAccountUsers();
    test:assertTrue(response.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
isolated function testCreateAccountUser() returns error? {
    if isLiveServer {
        return;
    }
    User response = check runzero->createAccountUser({firstName: "John", lastName: "Smith", email: "john.smith@acme.test"});
    test:assertEquals(response.email, "john.smith@acme.test");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAccountLicense() returns error? {
    License response = check runzero->getAccountLicense();
    test:assertTrue(response?.name !is ());
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetHostedZones() returns error? {
    HostedZone[] response = check runzero->getHostedZones();
    test:assertTrue(response.length() >= 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetAccountKeys() returns error? {
    APIKey[] response = check runzero->getAccountKeys();
    test:assertTrue(response.length() > 0);
}
