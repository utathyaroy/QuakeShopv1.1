@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    
        
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Parkway","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA","geometry":{"location":{"lat":37.422364,"lng":-122.084364},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4237129802915,"lng":-122.0830150197085},"southwest":{"lat":37.42101501970851,"lng":-122.0857129802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","types":["street_address"]}],"status":"OK"}');
        res.setStatusCode(200);
        return res;
    }
    

}