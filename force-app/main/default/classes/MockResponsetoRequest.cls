@RestResource(urlMapping='/kanat/v1/payment/*')
global class MockResponsetoRequest {

    @HttpPost
    global static String handleCapture() {
        // Access the incoming request
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Log the incoming request body for debugging
        System.debug('Request Body: ' + String.valueOf(req.requestBody));

        // Extract the transaction ID from the URL
        String mystr = req.requestURI;

        // Find the position of the last '/' character
        Integer lastSlashIndex = mystr.lastIndexOf('/');
        Integer secondLastSlashIndex = mystr.lastIndexOf('/', lastSlashIndex - 1);
        
        // Extract the second-to-last segment (Payment ID)
        String paymentId = mystr.substring(secondLastSlashIndex + 1, lastSlashIndex);
        System.debug('Extracted Payment ID: ' + paymentId);
        
        
        // Check if the payment ID exists in the captureTransactionIds
        Boolean hasPaymentId = MockPaymentAdapter.containsString(paymentId);    
        
        // If the payment ID is not found, return a 404 response
        if (!hasPaymentId) {
            res.statusCode = 404; // Not Found
            return JSON.serialize(new Map<String, String>{
                'error' => 'Payment ID not found.'
            });
        }

        // Parse the request body for application/x-www-form-urlencoded
        Map<String, String> requestMap = new Map<String, String>();
        String requestBody = req.requestBody.toString();
        
        if (!String.isEmpty(requestBody)) {
            // Split the body into key-value pairs
            List<String> pairs = requestBody.split('&');
            for (String pair : pairs) {
                List<String> keyValue = pair.split('=');
                if (keyValue.size() == 2) {
                    // Decode the key and value and put them in the map
                    String key = EncodingUtil.urlDecode(keyValue[0], 'UTF-8');
                    String value = EncodingUtil.urlDecode(keyValue[1], 'UTF-8');
                    requestMap.put(key, value);
                }
            }
        }

        // Check for error condition based on transaction ID
        if (paymentId == 'TX123456789010') {
            return MockPaymentAdapter.getErrorResponse();
        }

        // Handle Full Capture (no request body)
        if (String.isEmpty(requestBody)) {
            String idempotencyKey = req.headers.get('x-pgw-idempotency-key');
            String captureAmount = '900.0'; // Default amount for full capture
            String currencyval = 'USD'; // Default currency for full capture
            return MockPaymentAdapter.getFullCaptureSuccessResponse(paymentId, idempotencyKey, captureAmount, currencyval);
        }

        // Handle Partial Capture (request body present)
        String captureAmount = requestMap.get('capture_amount') == null ? '900.0' : requestMap.get('capture_amount');
        String currencyval = requestMap.get('currency') == null ? 'USD' : requestMap.get('currency');
        String idempotencyKey = req.headers.get('x-pgw-idempotency-key');

        // Log the capture details
        System.debug('Capture Amount: ' + captureAmount);
        System.debug('Currency: ' + currencyval);
        System.debug('Idempotency Key: ' + idempotencyKey);

        return MockPaymentAdapter.getPartialCaptureSuccessResponse(paymentId, 'TX123456789001'); // Example child transaction ID
    }
    
    @Httpget
    global static String getCaptureStatus(){
        RestRequest req = RestContext.Request;
        RestResponse res = RestContext.Response;
        String mystr = req.requestURI;

        // Find the position of the last '/' character
        Integer lastSlashIndex = mystr.lastIndexOf('/');
        Integer secondLastSlashIndex = mystr.lastIndexOf('/', lastSlashIndex - 1);
        
        // Extract the second-to-last segment (Payment ID)
        String paymentId = mystr.substring(secondLastSlashIndex + 1, lastSlashIndex);
        System.debug('Extracted Payment ID: ' + paymentId);
        
        
        // Check if the payment ID exists in the captureTransactionIds
        Boolean hasPaymentId = MockPaymentAdapter.containsString(paymentId);
        
        // If the payment ID is not found, return a 404 response
        if (!hasPaymentId) {
            res.statusCode = 404; // Not Found
            return JSON.serialize(new Map<String, String>{
                'error' => 'Payment ID not found.'
            });
        }
        
        Map<String, String> requestMap = new Map<String, String>();
        String requestBody = req.requestBody.toString();
        
        if (!String.isEmpty(requestBody)) {
            // Split the body into key-value pairs
            List<String> pairs = requestBody.split('&');
            for (String pair : pairs) {
                List<String> keyValue = pair.split('=');
                // Decode the key and value and put them in the map
                String key = EncodingUtil.urlDecode(keyValue[0], 'UTF-8');
                String value = EncodingUtil.urlDecode(keyValue[1], 'UTF-8');
                requestMap.put(key, value);
            }
        }
        
       
        
        
        
        return '200';
        
        
            
        
        
    }
}