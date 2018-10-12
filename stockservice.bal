import ballerina/http;
import ballerina/log;

type StockRecord record {
    int total;
    int vestedAmount;
};
StockRecord stockRecord1 = {total: 100, vestedAmount: 90};
StockRecord stockRecord2 = {total: 120, vestedAmount: 105};
StockRecord stockRecord3 = {total: 200, vestedAmount: 160};
StockRecord stockRecord4 = {total: 75, vestedAmount: 55};
map stockOptionMap = { "001" : stockRecord1 , "002": stockRecord2, "003": stockRecord3, "004": stockRecord4 };

@http:ServiceConfig {
    basePath:"/stocks"
}
service<http:Service> hello bind { port: 9090 } {

    @http:ResourceConfig {
        methods:["GET"],
        path:"/{userId}/options"
    }
    getEmployeeId (endpoint caller, http:Request req, string userId) {
        http:Response res = new;
        if (stockOptionMap.hasKey(userId)) {
            StockRecord stockRecord = check <StockRecord>stockOptionMap[userId];
            json stockResult = { options: { total: stockRecord.total, vestedAmount: stockRecord.vestedAmount} } ;
            res.setJsonPayload(stockResult);
        } else {
            res.statusCode = 404;
        }
        caller->respond(res) but { error e => log:printError("Error sending response", err = e) };
    }
}