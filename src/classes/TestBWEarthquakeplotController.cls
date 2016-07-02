@isTest
public class TestBWEarthquakeplotController {
    
    @isTest static void testcontroller(){
        
        BW_EarthquakePlotController b = new BW_EarthquakePlotController();
        b.callGetInfo();
        BW_EarthquakePlotController.getEQResult('San Francisco');
        
    }
    

}