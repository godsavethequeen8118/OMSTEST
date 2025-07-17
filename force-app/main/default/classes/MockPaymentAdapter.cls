public class MockPaymentAdapter {
    
    // Set for transaction IDs
    private static Set<String> captureTransactionIds = new Set<String>{
        'TX123456789001', 'TX123456789002', 'TX123456789003', 
        'TX123456789004', 'TX123456789005', 'TX123456789006', 
        'TX123456789007', 'TX123456789008', 'TX123456789009', 
        'TX123456789010'
    };

    // Method to get a full capture success response
    public static String getFullCaptureSuccessResponse(String paymentId, String idempotencyKey, String captureAmount, String currencyval) {
        // Simulate payment processing logic
        Map<String, Object> responseMap = new Map<String, Object>();
        responseMap.put('transaction_id', paymentId);
        responseMap.put('idempotency_key', idempotencyKey);
        responseMap.put('transaction_status', 'PROCESSING'); // Simulate processing status
        responseMap.put('amount', captureAmount);
        responseMap.put('currency', currencyval);
        
        // Simulate card details
        Map<String, Object> cardDetails = new Map<String, Object>();
        cardDetails.put('brand', 'VISA');
        cardDetails.put('first_six_digits', '444444');
        cardDetails.put('last_four_digits', '4448');
        cardDetails.put('expiry_month', 11);
        cardDetails.put('expiry_year', 25);
        responseMap.put('card', cardDetails);

        // Simulate account details
        Map<String, Object> accountDetails = new Map<String, Object>();
        accountDetails.put('account_type', 'GLOBAL_NA');
        accountDetails.put('account_id', 'abcdef1234567890');
        responseMap.put('account', accountDetails);

        // Simulate service details
        Map<String, Object> serviceDetails = new Map<String, Object>();
        serviceDetails.put('service_type', 'NX_ESHOP');
        serviceDetails.put('service_transaction_id', '12345');
        serviceDetails.put('service_country', 'GB');
        responseMap.put('service', serviceDetails);

        // Simulate timestamps
        responseMap.put('authorized_at', String.valueOf(DateTime.now().getTime()));
        responseMap.put('captured_at', String.valueOf(DateTime.now().getTime() + 5));

        // Return the simulated response
        return JSON.serialize(responseMap);
    }

    // Method to get a partial capture success response
    public static String getPartialCaptureSuccessResponse(String parentTransactionId, String childTransactionId) {
        Map<String, Object> responseMap = new Map<String, Object>();
        
        // Child transaction details
        Map<String, Object> childTransactionMap = new Map<String, Object>();
        childTransactionMap.put('transaction_id', childTransactionId);
        childTransactionMap.put('child_id', '1');
        childTransactionMap.put('idempotency_key', 'A123456B');
        childTransactionMap.put('transaction_status', 'PROCESSING');
        childTransactionMap.put('amount', '30.50');
        childTransactionMap.put('psp_transaction_id', '8ac7a4a2762d4baf01763fceebd64be2');
        
        // Parent transaction details
        responseMap.put('transaction_id', parentTransactionId);
        responseMap.put('child_transaction', childTransactionMap);
        responseMap.put('transaction_status', 'SPLITTED');
        responseMap.put('amount', '540.00');
        
        return JSON.serialize(responseMap);
    }
    
    // Method to simulate an error response (for both full and partial)
    public static String getErrorResponse() {
        Map<String, Object> errorMap = new Map<String, Object>();
        
        Map<String, Object> kanatError = new Map<String, Object>();
        kanatError.put('flg_unrepairable', false);
        kanatError.put('flg_invalid_token', false);
        
        Map<String, Object> pgwError = new Map<String, Object>();
        pgwError.put('flg_unrepairable', false);
        pgwError.put('flg_invalid_token', false);
        pgwError.put('payment_method', 'paypal');
        
        Map<String, Object> pspCorrelation = new Map<String, Object>();
        pspCorrelation.put('error_code', 'UNPROCESSABLE_ENTITY');
        pspCorrelation.put('contact_id', 'd94729d0ab7ac');
        pspCorrelation.put('contact_to', 'PAYPAL_CS');
        errorMap.put('error', new Map<String, Object>{
            'code' => '5920',
            'message' => 'Internal server error.',
            'additional_info' => new Map<String, Object>{
                'kanat_error' => kanatError,
                'pgw_error' => pgwError,
                'psp_correlation' => pspCorrelation
            }
        });
        
        return JSON.serialize(errorMap);
    }

    // Method to check if a payment ID exists in the capture transaction IDs
    public static boolean containsString(String paymentId) {
        return captureTransactionIds.contains(paymentId);
    }
}