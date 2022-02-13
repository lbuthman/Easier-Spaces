@IsTest
public class ReservationManagerControllerTest {
    @TestSetup
    static void setup() {
        List<Account> accts = TestDataFactory.makeAccounts(15);
        List<Contact> contacts = TestDataFactory.makeContacts(25);
        List<Lead> leads = TestDataFactory.makeLeads(25);
        List<Market__c> markets = TestDataFactory.makeMarkets(25);
        List<Space__c> allSpaces = new List<Space__c>();
        List<Reservation__c> reservs = TestDataFactory.makeReservations(12);

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
        insert allSpaces;

        counter = 0;
        for (Reservation__c r : reservs) {
            r.Market__c = markets[0].Id;
            if (Math.mod(counter, 2) == 0) {
                r.Contact__c = contacts[counter]?.Id;
                r.Status__c = 'Draft';
            } else {
                r.Lead__c = leads[counter]?.Id;
                r.Status__c = 'Not Started';
            }
            counter++;
        }
        insert reservs;
    }

    @IsTest
    static void canFetchCustomers() {
        List<CustomerServices.Customer> contacts = ReservationManagerController.getCustomerList(
            'Contact'
        );
        System.assertNotEquals(contacts, null);
        List<CustomerServices.Customer> leads = ReservationManagerController.getCustomerList(
            'Lead'
        );
        System.assertNotEquals(leads, null);
        System.assertNotEquals(contacts, leads);
    }

    @IsTest
    static void canFetchOpenReservs() {
        List<Reservation__c> reservs = ReservationManagerController.getOpenReservations();
        System.assertNotEquals(reservs, null);
        System.assertEquals(reservs.size(), 10);
    }
}
