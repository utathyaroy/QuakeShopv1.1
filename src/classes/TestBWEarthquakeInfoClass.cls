@isTest
public class TestBWEarthquakeInfoClass {
    
    @isTest static void testGetInfo(){
        BWEarthquakeInfoClass bweq = new BWEarthquakeInfoClass();
        Test.startTest();
        bweq.getInfo('GetEQInfoByLocationName', new List<String>{'San  Francisco'});
        bweq.getInfo('GetEQInfoTopTen', null);
        bweq.getInfo('', null);
        Test.stopTest();
        
        
        
    }

}