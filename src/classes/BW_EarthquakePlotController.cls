public class BW_EarthquakePlotController {
    
    public Static BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl resultstring{get;set;} 
    public BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl topResults{get;set;} 
    
    public 	BW_EarthquakePlotController(){
        BWEarthquakeInfoClass rstcall = new BWEarthquakeInfoClass();
        topResults = (BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl)rstcall.getInfo('GetEQInfoTopTen', null);
        
        //Requested Partition for caching. Request Pending
        //topResults = (RESTCallcouts.EarthquakeResponseObject)Cache.Session.get('topeartquakedata');
    }
    //Init Method to Call Webservice to Call the Top Ten Earthquake Service and cache it.
     /* public void init() {  
        system.debug('Inside Init');
        if (!Cache.Session.contains('topeartquakedata')) {
        System.debug('Inside Cache If');
        RESTCallcouts rstcall = new RESTCallcouts();
        RESTCallcouts.EarthquakeResponseObject tr = (RESTCallcouts.EarthquakeResponseObject)rstcall.getCalloutResponseContents('');
        Cache.Session.put('topeartquakedata', tr);
        system.debug(Cache.Session.get('topeartquakedata'));
        }
        
        }*/
            
    public void callGetInfo(){
        BWEarthquakeInfoClass rstcall = new BWEarthquakeInfoClass();
        topResults = (BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl)rstcall.getInfo('GetEQInfoTopTen', null);
    }
    
    @RemoteAction
    public Static BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl getEQResult(String input){
        ApexPages.getMessages().clear();

        List<String> stringresult = new List<String>();
        System.debug('inside controller');
        BWEarthquakeInfoClass rstcall = new BWEarthquakeInfoClass();
        resultstring = (BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl)rstcall.getInfo('GetEQInfoByLocationName',new List<String>{input});
        system.debug('from controller'+resultstring);        
        return resultstring;
    }

}