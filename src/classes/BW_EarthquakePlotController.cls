public class BW_EarthquakePlotController {
    
    public Static BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl resultstring{get;set;} 
    public BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl topResults{get;set;} 
    
    public 	BW_EarthquakePlotController(){

    }
    //Init Method to Call Webservice to Call the Top Ten Earthquake Service and cache it.
    public void init() {  
        system.debug('Inside Init');
        try{
            if (!Cache.Org.contains('tabs.MyPartition.topeartquakedata')) {
            System.debug('Inside Cache If');
            BWEarthquakeInfoClass rstcall = new BWEarthquakeInfoClass();
            topResults = (BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl)rstcall.getInfo('GetEQInfoTopTen', null);
            Cache.Org.put('tabs.MyPartition.topeartquakedata', topResults, 3600);
        }else{
            system.debug('inside else');
            topResults = (BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl)Cache.Org.get('tabs.MyPartition.topeartquakedata');
            if(topResults==null){// Dev Org Cache trial Expires in 6 months. this is a precautionry code block
               	BWEarthquakeInfoClass rstcall = new BWEarthquakeInfoClass();
           		topResults = (BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl)rstcall.getInfo('GetEQInfoTopTen', null);
                
 
            }
        }
        }Catch(Exception e){
            topResults = new BWEarthquakeInfoClass.BWEarthquakeInfoResponseImpl();
            topResults.StatusDesc = 'ERROR';
            topResults.errorMessage = 'Error:'+e.getMessage();
            
        }
        

        
    }
            
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