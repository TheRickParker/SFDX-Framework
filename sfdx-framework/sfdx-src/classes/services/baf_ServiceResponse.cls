public inherited sharing class baf_ServiceResponse {
    public baf_ServiceRequest Request { get; set; }
    public baf_RequestStatus Status { get; set; }
    public Exception ThrownException { get; set; }
    public Object Data { get; set; }

    public baf_ServiceResponse(baf_ServiceRequest req) {
        Request = req;
    }

    public baf_ServiceResponse(baf_ServiceRequest req, baf_RequestStatus stat) {
        Request = req;
        Status = stat;
    }

    public baf_ServiceResponse(baf_ServiceRequest req, baf_RequestStatus stat, Exception ex) {
        Request = req;
        Status = stat;
        ThrownException = ex;
    }

    public baf_ServiceResponse(baf_ServiceRequest req, baf_RequestStatus stat, Object dt) {
        Request = req;
        Status = stat;
        Data = dt;
    }
}