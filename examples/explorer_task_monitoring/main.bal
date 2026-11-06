// Reports the connection state of the explorers of a runZero organization and the tasks in a given status.

import ballerina/io;
import ballerinax/runzero;

configurable string apiToken = ?;
configurable string taskStatus = "active";

public function main() returns error? {
    runzero:Client runzeroClient = check new ({auth: {token: apiToken}});

    // Step 1: Check which explorers are connected
    runzero:Explorer[] explorers = check runzeroClient->getExplorers();
    int connected = 0;
    foreach runzero:Explorer explorer in explorers {
        boolean isConnected = explorer.connected ?: false;
        if isConnected {
            connected += 1;
        }
        io:println(explorer.name ?: explorer.id, " connected: ", isConnected);
    }
    io:println(connected, " of ", explorers.length(), " explorers are connected");

    // Step 2: List the tasks in the requested status
    runzero:Task[] tasks = check runzeroClient->getTasks(status = taskStatus);
    io:println(tasks.length(), " task(s) with status '", taskStatus, "'");

    // Step 3: Show the details of each task
    foreach runzero:Task task in tasks {
        string taskId = task.id ?: "";
        if taskId == "" {
            continue;
        }
        runzero:Task detail = check runzeroClient->getTask(taskId);
        io:println(detail.name ?: taskId, " | ", detail.'type ?: "unknown", " | ", detail.status ?: "unknown");
    }
}
