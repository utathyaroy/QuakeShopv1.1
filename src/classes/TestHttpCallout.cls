@isTest
private class TestHttpCallout {
     @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         RESTCallout restcallout = new RESTCallout('dummy endpoint');
       String res = restcallout.doGetCall();

    }
}