@IsTest
public class MarketServicesTest {
    @TestSetup
    static void setup() {
        List<Account> accts = TestDataFactory.makeAccounts(15);
        List<Contact> contacts = TestDataFactory.makeContacts(25);
        List<Lead> leads = TestDataFactory.makeLeads(25);
        List<Market__c> markets = TestDataFactory.makeMarkets(25);
        List<Space__c> allSpaces = new List<Space__c>();

        insert leads;
        insert accts;
        Integer counter = 0;
        for (Contact c : contacts) {
            c.AccountId = accts[counter].Id;
            counter++;
            if (counter >= accts.size()) {
                counter = 0;
            }
        }
        insert contacts;

        insert markets;
        for (Integer i = 0; i < markets.size(); i++) {
            List<Space__c> spaces = TestDataFactory.makeSpaces(12);
            for (Space__c s : spaces) {
                s.Market__c = markets[i].Id;
            }
            allSpaces.addAll(spaces);
        }
        System.debug(allSpaces.size());
        insert allSpaces;
    }

    @IsTest
    static void canFetchRelatedSpaces() {
        List<Market__c> markets = [SELECT Id FROM Market__c LIMIT 5];
        List<Space__c> one = MarketServices.getRelatedSpaces(markets[0].Id);
        List<Space__c> two = MarketServices.getRelatedSpaces(markets[3].Id);
        System.assertNotEquals(one, null);
        System.assertNotEquals(two, null);
        System.assertNotEquals(one, two);
        System.assertEquals(one.size(), 12);
        System.assertEquals(two.size(), 12);
    }
}
