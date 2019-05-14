/**************************************************************************************************
 *
 *  Apex Class:   
 *
 *  @description : This is a test class to test CalendarEventClass behaviour
 *  @author : kajal@testcompany.com
 *  @date : 14/05/2019
 * 
 *************************************************************************************************/
@isTest(seeAllData=true)
public class CalendarEventClassTest {
	static testMethod void getEventsTest() {
        CalendarEventClass.getEvents('Event', 'Subject', 'StartDateTime', 'EndDateTime', 'WhoId', 'Description', 'OwnerId', true);
        CalendarEventClass.getEvents('Event', 'Subject', 'StartDateTime', 'EndDateTime', 'WhoId', 'Description', 'OwnerId', false);
    }
    static testMethod void upsertEventsTest() {
        CalendarEventClass.upsertEvents('{"title":"dasdsad","startDateTime":"2017-04-26T17:00:00-07:00","endDateTime":"2017-04-26T19:00:00-07:00","description":"asdasd"}', 'Event', 'Subject', 'StartDateTime', 'EndDateTime', 'WhoId', 'Description', 'OwnerId');
    	CalendarEventClass.upsertEvents('{"id":"sadad","title":"dasdsad","startDateTime":"2017-04-26T17:00:00-07:00","endDateTime":"2017-04-26T19:00:00-07:00","description":"asdasd"}', 'Event', 'Subject', 'StartDateTime', 'EndDateTime', 'WhoId', 'Description', 'OwnerId');
    }
    static testMethod void deleteEventTest() {
        CalendarEventClass.deleteEvent('00U41000006bFIA', 'Event', 'Subject', 'StartDateTime', 'EndDateTime', 'Description', 'OwnerId');
    }
    static testMethod void crudSecurityTest() {
        CalendarEventClass.isAccessible('Event');
        CalendarEventClass.isAccessible('Event','Subject');
        CalendarEventClass.isCreateable('Event');
        CalendarEventClass.isDeletable('Event');
    }
}