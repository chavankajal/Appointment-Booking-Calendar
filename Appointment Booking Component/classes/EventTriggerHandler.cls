/**************************************************************************************************
 *
 *  Apex Class:   
 *
 *  @description : This is a trigger handler for Event object 
 *  @author : kajal@testcompany.com
 *  @date : 13/05/2019
 * 
 *************************************************************************************************/
public class EventTriggerHandler {
    public static Event_Calendar__c custSet = Event_Calendar__c.getOrgDefaults();
    public static string outboundEmail = custSet.Outbound_Email_Address__c;
    
    
	//After Insert
    public static void handleAfterInsert(List<Event> eventNew) {
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        //Create a new Email
     	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> sendTo = new List<String>();
        contact conObj = new contact();
        
        for(Event evtObj : eventNew){
            conObj = [select Email, FirstName, LastName from contact where id =: evtObj.WhoId];
            
            sendTo.add(conObj.Email);
            mail.setToAddresses(sendTo);
            mail.setTargetObjectId(evtObj.WhoId);
            
            //Set who the email is sent from
            mail.setReplyTo(outboundEmail);
            mail.setSenderDisplayName(UserInfo.getUserName());
            mail.setSubject(evtObj.Subject);
            String body = 'Dear ' + conObj.FirstName + ' ' + conObj.LastName + ',\n';
            body += 'New Appointment with below details has been booked for you. \n';
            body += 'Day : ' + evtObj.StartDateTime.date() + '\n';
            body += 'Start Time : ' + evtObj.StartDateTime.time() + '\n';
            body += 'End Time : ' + evtObj.EndDateTime.time() + '\n';
            body += 'Regards,' + '\n';
            body += UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
     		mail.setHtmlBody(body);
            
            mails.add(mail);
        	Messaging.sendEmail(mails);
        }
    }
}