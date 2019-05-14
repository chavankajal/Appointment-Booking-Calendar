/**************************************************************************************************
 *
 *  Apex Class:   
 *
 *  @description : This is a inbound email service handler class 
 *  @author : kajal@testcompany.com
 *  @date : 11/05/2019
 * 
 *************************************************************************************************/
global class AppointmentEmailHandler implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
             System.debug('inside email service class');

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        System.debug('inside email service'); 
        String emailBody = email.plainTextBody;
        String emailSubject = email.Subject;
        emailSubject = emailSubject.removeStart('Re: ');
        Event evt = [SELECT Id 
                     FROM Event 
                     WHERE subject=:emailSubject
                     LIMIT 1];
        
        if(evt != null) {
            if(emailBody.contains('Accepted')) {
                evt.Booking_Confirmed__c = true;
                System.debug('Booking_Confirmed');
            }
            update evt;
        }
        return result;
    }
}