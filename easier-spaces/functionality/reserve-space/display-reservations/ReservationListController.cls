/**
 * Created by lbuthman on 2/17/22.
 */

public with sharing class ReservationListController {

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
