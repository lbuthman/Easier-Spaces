@IsTest
public class CustomerServicesTest {
    @IsTest
    static void canFetchCustomerFields() {
        CustomerServices.Customer contact = CustomerServices.getCustomerFields(
            'Contact'
        );
        System.assertNotEquals(contact, null);
        CustomerServices.Customer lead = CustomerServices.getCustomerFields(
            'Lead'
        );
        System.assertNotEquals(lead, null);
        System.assertNotEquals(contact, lead);
    }
}
