public inherited sharing class CustomerServices {
    @AuraEnabled(Cacheable=true)
    public static Customer getCustomerFields(String objectType) {
        Customer customer;
        for (Customer_Fields__mdt c : [
            SELECT
                Customer_Name__r.QualifiedApiName,
                Customer_Email__r.QualifiedApiName,
                Customer_City__r.QualifiedApiName,
                Customer_State__r.QualifiedApiName,
                Customer_Status__r.QualifiedApiName
            FROM Customer_Fields__mdt
            WHERE Sobject_Type__r.QualifiedApiName = :objectType
            WITH SECURITY_ENFORCED
        ]) {
            customer = new Customer(
                c.Customer_Name__r.QualifiedApiName,
                c.Customer_Email__r.QualifiedApiName,
                c.Customer_City__r.QualifiedApiName,
                c.Customer_State__r.QualifiedApiName,
                '',
                ''
            );
        }
        return customer;
    }

    public class Customer {
        //attributes that we associate with customers
        @AuraEnabled
        public String email { get; set; }

        @AuraEnabled
        public String name { get; set; }

        @AuraEnabled
        public String city { get; set; }

        @AuraEnabled
        public String state { get; set; }

        @AuraEnabled
        public String status { get; set; }

        @AuraEnabled
        public String Id { get; set; }

        //putting them together, we get our wrapper object:
        public Customer(
            String name,
            String email,
            String city,
            String state,
            String status,
            String custId
        ) {
            this.name = name;
            if (String.isNotEmpty(email)) {
                this.email = email;
            }
            if (String.isNotEmpty(city)) {
                this.city = city;
            }
            if (String.isNotEmpty(state)) {
                this.state = state;
            }
            if (String.isNotEmpty(status)) {
                this.status = status;
            }
            if (String.isNotEmpty(custId)) {
                this.Id = custId;
            }
        }
    }
}
