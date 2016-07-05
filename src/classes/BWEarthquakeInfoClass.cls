/*
* Author:Utathya Roy
* Description : This Class takes in request for hitting the BW Geoname Services and return results back .
* 
*/
public class BWEarthquakeInfoClass {
    
    RestCallout restcallout;
    
    public BWEarthquakeInfoClass(){
        
    }
    
    
    /*
*Method:Takes in a request Type and related parameters and route the call the appropriate methods
* 
*/
    public BWEarthquakeInfoResponseImpl getInfo( String requestType, List<String> parameters){
        BWEarthquakeInfoResponseImpl bwr;
        Location currentLocation;
        Double north;
        Double south;
        Double east;
        Double west;
        
        if(requestType!=null && requestType.trim() == 'GetEQInfoByLocationName' )
        {			
            if(parameters !=null){
                
                bwr = getGeocodeResults(parameters[0]);
                if(Test.isRunningTest()){
                    String dummyb = '{"results":[{"address_components":[{"long_name":"1600","short_name":"1600","types":["street_number"]},{"long_name":"Amphitheatre Parkway","short_name":"Amphitheatre Pkwy","types":["route"]},{"long_name":"Mountain View","short_name":"Mountain View","types":["locality","political"]},{"long_name":"Santa Clara County","short_name":"Santa Clara County","types":["administrative_area_level_2","political"]},{"long_name":"California","short_name":"CA","types":["administrative_area_level_1","political"]},{"long_name":"United States","short_name":"US","types":["country","political"]},{"long_name":"94043","short_name":"94043","types":["postal_code"]}],"formatted_address":"1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA","geometry":{"location":{"lat":37.422364,"lng":-122.084364},"location_type":"ROOFTOP","viewport":{"northeast":{"lat":37.4237129802915,"lng":-122.0830150197085},"southwest":{"lat":37.42101501970851,"lng":-122.0857129802915}}},"place_id":"ChIJ2eUgeAK6j4ARbn5u_wAGqWA","types":["street_address"]}],"status":"OK"}';
                    bwr = (BWEarthquakeInfoResponseImpl)JSON.deserialize(dummyb, BWEarthquakeInfoResponseImpl.class);
                }
                if(bwr!=null && bwr.results!=null 
                   && bwr.results.size()>0
                   && bwr.results[0]!=null
                   && bwr.results[0].geometry!=null
                   && bwr.results[0].geometry.location!=null ){
                       currentLocation = bwr.results[0].geometry.location;
                   }
                if(bwr!=null && bwr.results!=null 
                   && bwr.results.size()>0
                   && bwr.results[0]!=null 
                   && bwr.results[0].geometry!=null){
                    if(bwr.results[0].geometry.bounds!=null && bwr.results[0].geometry.bounds.northeast!=null
                       &&bwr.results[0].geometry.bounds.southwest!=null){
                           north =bwr.results[0].geometry.bounds.northeast.lat;
                           east =bwr.results[0].geometry.bounds.northeast.lng;
                           south=bwr.results[0].geometry.bounds.southwest.lat;
                           west=bwr.results[0].geometry.bounds.southwest.lng;  
                       }else{//Sometimes Bounds are sent i the response. In such scenarios a assume 1 degree around the center
                           north = bwr.results[0].geometry.location.lat+1;
                           south = bwr.results[0].geometry.location.lat -1;
                           east = bwr.results[0].geometry.location.lng +1;
                           west = bwr.results[0].geometry.location.lng -1;
                       }
                    
                    system.debug('north'+north+'South'+south+'east'+east+'west'+west);
                    
                    bwr =new BWEarthquakeInfoResponseImpl();
                    bwr = getGeonameEQResults(north, south, east, west, false);
                    if(Test.isRunningTest()){
                        String dummyR = '{"earthquakes":[{"datetime":"2011-03-11 04:46:23","depth":24.4,"lng":142.369,"src":"us","eqid":"c0001xgp","magnitude":8.8,"lat":38.322},{"datetime":"2012-04-11 06:38:37","depth":22.9,"lng":93.0632,"src":"us","eqid":"c000905e","magnitude":8.6,"lat":2.311},{"datetime":"2007-09-12 09:10:26","depth":30,"lng":101.3815,"src":"us","eqid":"2007hear","magnitude":8.4,"lat":-4.5172},{"datetime":"2012-04-11 08:43:09","depth":16.4,"lng":92.4522,"src":"us","eqid":"c00090da","magnitude":8.2,"lat":0.7731},{"datetime":"2007-04-01 18:39:56","depth":10,"lng":156.9567,"src":"us","eqid":"2007aqbk","magnitude":8,"lat":-8.4528},{"datetime":"2015-04-25 06:13:40","depth":15,"lng":84.6493,"src":"us","eqid":"us20002926","magnitude":7.9,"lat":28.1306},{"datetime":"2007-09-12 21:49:01","depth":10,"lng":100.9638,"src":"us","eqid":"2007hec6","magnitude":7.8,"lat":-2.5265},{"datetime":"2016-03-02 12:55:00","depth":24,"lng":94.275,"src":"us","eqid":"us10004u1y","magnitude":7.8,"lat":-4.9082},{"datetime":"2015-05-30 11:36:00","depth":677.56,"lng":140.4932,"src":"us","eqid":"us20002ki3","magnitude":7.8,"lat":27.8312},{"datetime":"2013-04-16 08:44:20","depth":82,"lng":62.0532,"src":"us","eqid":"b000g7x7","magnitude":7.8,"lat":28.1069}]}';
                        bwr = (BWEarthquakeInfoResponseImpl)JSON.deserialize(dummyR, BWEarthquakeInfoResponseImpl.class);
                        
                    }
                    if(bwr !=null){
                        if(bwr.statusDesc!='ERROR'){
                            if(bwr.earthquakes!=null && bwr.earthquakes.size()>0){
                                bwr.location = currentLocation;
                                bwr.statusDesc='SUCCESS'; 
                            }else{
                                bwr.statusDesc='ERROR';
                                bwr.errorMessage = 'No Records were found within the bounding box for selected location.';
                                bwr.location = currentLocation;
                            }
                            
                        }
                        
                    }else{
                        
                        bwr.statusDesc='ERROR';
                        bwr.errorMessage = 'Not a Valid Request for Geoname Earthquake Service.';
                        
                    }
                }else{
                    if(bwr!=null &&bwr.statusDesc!='ERROR'){
                        bwr.statusDesc='ERROR';
                        bwr.errorMessage = 'Not a Valid Location.';
                    }  
                }
            }   
        }else if((requestType!=null && requestType.trim() == 'GetEQInfoTopTen' )){
            String now = String.valueOf(System.now());
            String yr = String.valueOf(Integer.valueOf(System.today().year())-1);
			system.debug('now'+ String.valueOf(now));
            String lstyearst = yr+now.mid(5,2)+now.mid(8,2);
            System.debug('last Year'+lstyearst);
            Integer lstyearint = Integer.valueOf(lstyearst);
            List<EarthQuake> erqList = new List<EarthQuake>();
            List<EarthQuake> topTenerqList = new List<EarthQuake>();
            bwr =new BWEarthquakeInfoResponseImpl();
            bwr = getGeonameEQResults(90, -90, 180, -180, true);
            
            if(Test.isRunningTest()){
                String dummyR = '{"earthquakes":[{"datetime":"2011-03-11 04:46:23","depth":24.4,"lng":142.369,"src":"us","eqid":"c0001xgp","magnitude":8.8,"lat":38.322},{"datetime":"2012-04-11 06:38:37","depth":22.9,"lng":93.0632,"src":"us","eqid":"c000905e","magnitude":8.6,"lat":2.311},{"datetime":"2007-09-12 09:10:26","depth":30,"lng":101.3815,"src":"us","eqid":"2007hear","magnitude":8.4,"lat":-4.5172},{"datetime":"2012-04-11 08:43:09","depth":16.4,"lng":92.4522,"src":"us","eqid":"c00090da","magnitude":8.2,"lat":0.7731},{"datetime":"2007-04-01 18:39:56","depth":10,"lng":156.9567,"src":"us","eqid":"2007aqbk","magnitude":8,"lat":-8.4528},{"datetime":"2015-04-25 06:13:40","depth":15,"lng":84.6493,"src":"us","eqid":"us20002926","magnitude":7.9,"lat":28.1306},{"datetime":"2007-09-12 21:49:01","depth":10,"lng":100.9638,"src":"us","eqid":"2007hec6","magnitude":7.8,"lat":-2.5265},{"datetime":"2016-03-02 12:55:00","depth":24,"lng":94.275,"src":"us","eqid":"us10004u1y","magnitude":7.8,"lat":-4.9082},{"datetime":"2015-05-30 11:36:00","depth":677.56,"lng":140.4932,"src":"us","eqid":"us20002ki3","magnitude":7.8,"lat":27.8312},{"datetime":"2013-04-16 08:44:20","depth":82,"lng":62.0532,"src":"us","eqid":"b000g7x7","magnitude":7.8,"lat":28.1069}]}';
                bwr = (BWEarthquakeInfoResponseImpl)JSON.deserialize(dummyR, BWEarthquakeInfoResponseImpl.class);
                
            }
            if(bwr !=null){
                system.debug('bwr is not null'+bwr);
                if(bwr.statusDesc!='ERROR'){
                    system.debug('bwr is not error');
                    //identify the rows for last year and sort
                    if(bwr.earthquakes!=null && bwr.earthquakes.size()>0){
                        for(EarthQuake erq:bwr.earthquakes){
                            String d = erq.datetmst;
                            String tyst;
                            Integer tyint;
                            if(d!=null && d.trim()!=''){
                                tyst = d.mid(0,4)+d.mid(5,2)+d.mid(8,2);
								tyint = Integer.valueOf(tyst);
                            }
                            system.debug('tyint'+tyint);
                            system.debug('lstyearint'+lstyearint);
                            if(tyint>lstyearint){
                                erqList.add(erq);
                            }
                        }
                        erqList.sort();
                        if(erqList.size()>0){
                                                     for(Integer i = 0; i< 10;i++){
                                topTenerqList.add(erqList[i]);
                            }   
                        }

                        bwr.earthquakes=topTenerqList;
                        bwr.location = currentLocation;
                        bwr.statusDesc='SUCCESS'; 
                    }else{
                        bwr.statusDesc='ERROR';
                        bwr.errorMessage = 'No Records were found within the bounding box fo your search.';   
                    }
                }
            }else{
                bwr.statusDesc='ERROR';
                bwr.errorMessage = 'Not a Valid Request for Geoname Earthquake Service.';
            }
        }else{
            bwr = new BWEarthquakeInfoResponseImpl();
            bwr.statusDesc='ERROR';
            bwr.errorMessage = 'Not a Valid Request.';
        }
        system.debug('final response'+bwr);
        bwr.location = currentLocation;
        return bwr;
    }
    
    /*
*Method:Builds the end point to the Google Api Geocode Service and clls the request
* 
*/
    private BWEarthquakeInfoResponseImpl getGeocodeResults(String location){
        String serviceEndpoint;
        String responseString;
        serviceEndpoint = 'https://maps.googleapis.com/maps/api/geocode/json?';
        BWEarthquakeInfoResponseImpl resp;
        // String googleApiKey= [][0].tabs__Encrypted_Info__c;
        BWEarthquakeInfoResponseImpl bwResp;
        try{
            String googleapikey;
            String response;
            if(!Test.isRunningTest()){
                googleapikey=[Select tabs__Encrypted_Info__c, tabs__name__c from tabs__BW_Configuration__c where tabs__name__c  = 'Google API Org Key'][0].tabs__Encrypted_Info__c;
                
                
                serviceEndpoint = serviceEndpoint +'address='+EncodingUtil.urlEncode(location,'UTF-8')+'&key='+googleapikey;
                restcallout = new RESTCallout(serviceEndpoint);
                response = restcallout.doGetCall();
            }
            
            
            bwResp = (BWEarthquakeInfoResponseImpl)JSON.deserialize(response, BWEarthquakeInfoResponseImpl.class);
            system.debug('After************** callout');
            System.debug('bwResp*************'+bwResp);
            bwResp.statusDesc='SUCCESS';
            bwResp.errorMessage = '';
        }catch(CalloutException coe){
            system.debug('Inside callout');
            bwResp = new BWEarthquakeInfoResponseImpl();
            bwResp.statusDesc = 'ERROR';
            bwResp.errorMessage = coe.getMessage();
            return bwResp;
        }catch(Exception e){
            bwResp = new BWEarthquakeInfoResponseImpl();
            bwResp.statusDesc = 'ERROR';
            bwResp.errorMessage = e.getMessage();
            return bwResp;
        }
        return bwResp;
        
    }
    /*
*Method:Builds the end point to the Geoname Earthquake Service and clls the request
* 
*/
    private BWEarthquakeInfoResponseImpl getGeonameEQResults(Double north, Double south, Double east, Double west, boolean isTopTen){
        BWEarthquakeInfoResponseImpl response;
        String endpoint;
        String geonameuser;
        String maxrows;
        String dt;
        Datetime now = System.now();
        try{
            endpoint = 'http://api.geonames.org/earthquakesJSON?';
            String restresponse;
            if(Test.isRunningTest()){
                geonameuser = 'utathyayor';
                restresponse = '{"earthquakes":[{"datetime":"2011-03-11 04:46:23","depth":24.4,"lng":142.369,"src":"us","eqid":"c0001xgp","magnitude":8.8,"lat":38.322},{"datetime":"2012-04-11 06:38:37","depth":22.9,"lng":93.0632,"src":"us","eqid":"c000905e","magnitude":8.6,"lat":2.311},{"datetime":"2007-09-12 09:10:26","depth":30,"lng":101.3815,"src":"us","eqid":"2007hear","magnitude":8.4,"lat":-4.5172},{"datetime":"2012-04-11 08:43:09","depth":16.4,"lng":92.4522,"src":"us","eqid":"c00090da","magnitude":8.2,"lat":0.7731},{"datetime":"2007-04-01 18:39:56","depth":10,"lng":156.9567,"src":"us","eqid":"2007aqbk","magnitude":8,"lat":-8.4528},{"datetime":"2015-04-25 06:13:40","depth":15,"lng":84.6493,"src":"us","eqid":"us20002926","magnitude":7.9,"lat":28.1306},{"datetime":"2007-09-12 21:49:01","depth":10,"lng":100.9638,"src":"us","eqid":"2007hec6","magnitude":7.8,"lat":-2.5265},{"datetime":"2016-03-02 12:55:00","depth":24,"lng":94.275,"src":"us","eqid":"us10004u1y","magnitude":7.8,"lat":-4.9082},{"datetime":"2015-05-30 11:36:00","depth":677.56,"lng":140.4932,"src":"us","eqid":"us20002ki3","magnitude":7.8,"lat":27.8312},{"datetime":"2013-04-16 08:44:20","depth":82,"lng":62.0532,"src":"us","eqid":"b000g7x7","magnitude":7.8,"lat":28.1069}]}';
            }
            if(!Test.isRunningTest()){
                geonameuser = [Select id, tabs__value__c from tabs__BW_Configuration__c where tabs__name__c  = 'Geoname User Id'][0].tabs__value__c;
                
            }
            endpoint = endpoint+'north='+north+'&south='+south+'&east='+east+'&west='+west+'&username='+geonameuser;
            if(isTopTen){
                dt = String.valueOf(now.year())+'-'+String.valueOf(now.month())+'-'+String.valueOf(now.day());
                if(!Test.isRunningTest()){
                    maxrows = [Select id, tabs__value__c from tabs__BW_Configuration__c where tabs__name__c  = 'MaxEarthQuakeRows'][0].tabs__value__c;  
                    
                }
                endpoint =endpoint+'&minMagnitude=7&maxRows='+maxrows+'&date='+dt;
            }
            restcallout = new RESTCallout(endpoint);
            if(!Test.isRunningTest()){
                restresponse = restcallout.doGetCall();
            }
            
            System.debug('restresponse'+restresponse);
            response = (BWEarthquakeInfoResponseImpl)JSON.deserialize(restresponse, BWEarthquakeInfoResponseImpl.class);
            System.debug('bwResp'+response);
            response.statusDesc='SUCCESS';
            response.errorMessage = '';
        }catch(CalloutException coe){
            response = new BWEarthquakeInfoResponseImpl();
            response.statusDesc = 'ERROR';
            response.errorMessage = coe.getMessage();
            return response;
            
        }catch(Exception e){
            response = new BWEarthquakeInfoResponseImpl();
            response.statusDesc = 'ERROR';
            response.errorMessage = e.getMessage();
            return response;
        }
        return response;
    }
    
    /*
* Responnse Inner Class that will be used to parse  the Service responses and deserialize it. The format of this class is
* exactly same as what the service response JSON returns.
*/
    public class BWEarthquakeInfoResponseImpl {
        public String statusDesc;
        public String errorMessage{get;set;}
        public List<Result> results;
        public String status;
        String originalLat;
        String originalLng;
        Location location;
        public List<EarthQuake> earthquakes{get;set;}    
    } 
    /*
* Supporting Inner Classwhich helps build the structure of BWEarthquakeInfoResponseImpl to match the service Response.
*/
    public Class Result{
        public String formatted_address;
        public Geometry geometry;
        
    } 
    /*
* Supporting Inner Classwhich helps build the structure of BWEarthquakeInfoResponseImpl to match the service Response.
*/
    public Class Geometry{
        public Location location;
        public Bounds bounds;
    }
    /*
* Supporting Inner Classwhich helps build the structure of BWEarthquakeInfoResponseImpl to match the service Response.
*/
    public Class Location{
        public Double lat;
        public Double lng;
    }
    /*
* Supporting Inner Classwhich helps build the structure of BWEarthquakeInfoResponseImpl to match the service Response.
*/
    public Class Bounds{
        public Northeast northeast; 
        public Southwest southwest; 
    }
    /*
* Supporting Inner Classwhich helps build the structure of BWEarthquakeInfoResponseImpl to match the service Response.
*/
    public Class Northeast{
        public Double lat;
        public Double lng;
    }
    /*
* Supporting Inner Classwhich helps build the structure of BWEarthquakeInfoResponseImpl to match the service Response.
*/
    public Class Southwest{
        public Double lat;
        public Double lng;
    }
    /*
* Supporting Inner Classwhich helps build the structure of BWEarthquakeInfoResponseImpl to match the service Response.
*/
    public Class EarthQuake implements Comparable{
        public String lng{get;set;}
        public String magnitude{get;set;}
        public String src{get;set;}
        public String depth{get;set;}
        public String lat{get;set;}
        public String datetmst{get;set;}
        //Sort as per magnitude
        Public Integer compareTo(Object obj){
            EarthQuake earthq = (EarthQuake)obj;
            if(Decimal.valueof(earthq.magnitude)>Decimal.valueOf(this.magnitude)){
                return 1;
            }else if(Decimal.valueOf(earthq.magnitude)==Decimal.valueOf(this.magnitude)){
                return 0;
            }else{
                return -1;
            }
        
        }
        
        
    } 
}