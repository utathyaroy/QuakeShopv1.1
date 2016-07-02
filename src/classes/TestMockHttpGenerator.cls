@isTest
public class TestMockHttpGenerator {

    @isTest static void testMockHTTPResponseMethod(){
        MockHttpResponseGenerator t = new MockHttpResponseGenerator();
        
        t.respond(new HttpRequest());
        
        
        
    }
    
}