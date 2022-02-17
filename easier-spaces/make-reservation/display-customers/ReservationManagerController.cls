public with sharing class ReservationManagerController {
    //Note: This is a sample, so we're using 'LIMIT' to simulate proper set/pagination controls
    @AuraEnabled(Cacheable=true)
    public static List<CustomerServices.Customer> getCustomerList(
        String sObjectType
    ) {
        List<CustomerServices.Customer> customers = new List<CustomerServices.Customer>();
        Customer_Fields__mdt c = [
            SELECT
                Customer_Name__r.QualifiedApiName,
                Customer_Email__r.QualifiedApiName,
                Customer_City__r.QualifiedApiName,
                Customer_State__r.QualifiedApiName,
                Customer_Status__r.QualifiedApiName,
                Customer_Draft_Status_Values__c
            FROM Customer_Fields__mdt
            WHERE Sobject_Type__r.QualifiedApiName = :sObjectType
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];

        List<String> draftStatus = new List<String>();
        draftStatus = c.Customer_Draft_Status_Values__c?.split(',');

        String query = 'SELECT ';
        query += c.Customer_Name__r.QualifiedApiName + ', ';
        query += c.Customer_Email__r.QualifiedApiName + ', ';
        query += c.Customer_City__r.QualifiedApiName + ', ';
        query += c.Customer_State__r.QualifiedApiName + ', ';
        query += c.Customer_Status__r.QualifiedApiName + ', ';
        query += 'Id';
        query += ' FROM ' + sObjectType;
        if (draftStatus.size() > 0) {
            query +=
                ' WHERE ' +
                c.Customer_Status__r.QualifiedApiName +
                ' IN: draftStatus';
        }
        query += ' WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC LIMIT 5';

        for (SObject sobj : Database.query(query)) {
            CustomerServices.Customer customer = new CustomerServices.Customer(
                (String) sobj.get(c.Customer_Name__r.QualifiedApiName),
                (String) sobj.get(c.Customer_Email__r.QualifiedApiName),
                (String) sobj.get(c.Customer_City__r.QualifiedApiName),
                (String) sobj.get(c.Customer_State__r.QualifiedApiName),
                (String) sobj.get(c.Customer_Status__r.QualifiedApiName),
                (String) sobj.get('Id')
            );
            customers.add(customer);
        }
        return customers;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Reservation__c> getOpenReservations() {
        return [
            SELECT
                Id,
                Name,
                Contact__c,
                Contact__r.Name,
                Lead__c,
                Lead__r.Name,
                Market__c,
                Market__r.Name,
                Status__c,
                Start_Date__c,
                End_Date__c,
                Total_Number_of_Guests__c
            FROM Reservation__c
            WHERE Status__c IN ('Not Started', 'Draft')
            WITH SECURITY_ENFORCED
            LIMIT 10
        ];
    }
}
