import ballerina/http;
import ballerina/log;

map<string> employeeIdMap = { "Bob": "001", "Alice": "002", "Jack": "003", "Pete": "004" };

@http:ServiceConfig {
    basePath:"/hr"
}
service<http:Service> hello bind { port: 9090 } {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{user}/employeeId"
    }
    getEmployeeId (endpoint caller, http:Request req, string user) {
        http:Response res = new;
        if (employeeIdMap.hasKey(user)) {
            json employeeIdJson = { id: employeeIdMap[user] };
            res.setJsonPayload(employeeIdJson);
        } else {
            res.statusCode = 404;
        }
        caller->respond(res) but { error e => log:printError("Error sending response", err = e) };
    }
}
