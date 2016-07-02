/*
 * Author:Utathya Roy
 * Description : Generic Rest Callout Class 
 * 
*/
public class RESTCallout {
    
    //Sample Sevice URLS for refernce
    //'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyBPsWvz8VGEm8tjV4Ep1TgdP4zRWDLiUcA';
    //'http://api.geonames.org/earthquakesJSON?north=44.1&south=-9.9&east=-22.4&west=55.2&username=utathyayor';
    //'http://api.geonames.org/earthquakesJSON?north=90&south=-90&east=180&west=-180&minMagnitude=7&username=utathyayor&date=2016-06-29';  
    
    Http h;
    HttpRequest req;
    HttpResponse res;
    String endpoint;
    /*
     * Constructor - Sets the Service End Point
     */
    public RESTCallout(String endpoint){
        this.endPoint =  endpoint;
        h = new HTTP();
    }
    /*
     * Method - Fires HTTP Get Calls
     */
    public String doGetCall(){
        String formattedResponse;
        if(endpoint!=null && endPoint.trim() !=''){
            HttpRequest req = new HttpRequest();
            system.debug('before callout');
            req.setEndpoint(endPoint);
            req.setMethod('GET');
            req.setTimeout(20000);
            HttpResponse res = h.send(req);
            formattedResponse =String.valueOf(res.getBody()).replace('datetime','datetmst');
        }
        return formattedResponse;
    }
    
}