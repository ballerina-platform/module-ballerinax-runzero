// Lists the sites of a runZero organization and prints the live assets discovered in one of them.

import ballerina/io;
import ballerinax/runzero;

configurable string apiToken = ?;
configurable string siteName = ?;
configurable int maxAssets = 10;

public function main() returns error? {
    runzero:Client runzeroClient = check new ({auth: {token: apiToken}});

    // Step 1: Find the site to report on
    runzero:Site[] sites = check runzeroClient->getSites();
    runzero:Site? selectedSite = ();
    foreach runzero:Site site in sites {
        if site.name == siteName {
            selectedSite = site;
        }
    }
    runzero:Site? found = selectedSite;
    if found is () {
        return error(string `Site '${siteName}' was not found in the organization`);
    }
    io:println("Site: ", found.name, " (", found.id, ")");

    // Step 2: List the assets of the site that are currently alive
    string query = string `site_id:${found.id} AND alive:t`;
    runzero:Asset[] assets = check runzeroClient->getAssets(search = query);
    io:println("Live assets: ", assets.length());

    // Step 3: Print the details of the first assets
    int shown = 0;
    foreach runzero:Asset asset in assets {
        if shown >= maxAssets {
            break;
        }
        runzero:Asset detail = check runzeroClient->getAsset(asset.id);
        string[] names = detail.names ?: [];
        io:println(detail.id, " | ", names.length() > 0 ? names[0] : "unnamed", " | ", detail.os ?: "unknown OS");
        shown += 1;
    }
}
