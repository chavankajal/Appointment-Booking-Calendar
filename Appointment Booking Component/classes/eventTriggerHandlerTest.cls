/**************************************************************************************************
 *
 *  Apex Class:   
 *
 *  @description : This is a test class to test EventTriggerHandler behaviour
 *  @author : kajal@testcompany.com
 *  @date : 14/05/2019
 * 
 *************************************************************************************************/
@isTest(seeAllData=true)
public class eventTriggerHandlerTest {
	static testMethod void handleAfterInsertTest() {
        Contact conObj = new Contact(FirstName = 'Contact', LastName = 'Name', email = 'chavankajal2208@gmail.com');
        insert conObj;
        list<Event> eventList = new list<Event>();
        Event evnObj = new Event(subject = 'Test Event',  StartDateTime = system.now(), endDateTime = system.now(), WhoId = conObj.Id);
        eventList.add(evnObj);
        insert eventList;
        EventTriggerHandler.handleAfterInsert(eventList);
    }
}