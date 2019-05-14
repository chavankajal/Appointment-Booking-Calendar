/**************************************************************************************************
 *
 *  Apex Class:   
 *
 *  @description : This is a calendar event handler class for calendar
 *  @author : kajal@testcompany.com
 *  @date : 12/05/2019
 * 
 *************************************************************************************************/
public with sharing class CalendarEventClass {
     @AuraEnabled
    public static List<EventObj> getEvents(String sObjectName, String titleField, String startDateTimeField, String endDateTimeField, String descriptionField, String contactNameField, String userField, Boolean filterByUserField){
        String q = 'SELECT Id,' + 
            String.valueOf(titleField) + ',' + 
            String.valueOf(startDateTimeField) + ',' +
            String.valueOf(endDateTimeField) + ',' +
            String.valueOf(descriptionField) + ',' +
            String.valueOf(contactNameField) + ',' +
            String.valueOf(userField) + ' FROM ' + 
            String.valueOf(sObjectName) + ' WHERE ' + 
            String.valueOf(userField) + ' = \'' + UserInfo.getUserId() + '\'';
        if (!filterByUserField) {
            q = 'SELECT Id,' + 
                String.valueOf(titleField) + ',' + 
            String.valueOf(startDateTimeField) + ',' +
            String.valueOf(endDateTimeField) + ',' +
            String.valueOf(descriptionField) + ',' +
            String.valueOf(userField) + ' FROM ' + 
            String.valueOf(contactNameField) + ',' +
            String.valueOf(sObjectName);
        } 
        
        List<sObject> sObjectList = Database.query(q);
        
        List<EventObj> eventRecords = new List<EventObj>();
        if(isAccessible(sObjectName)) {
            for (sObject obj : sObjectList) {
                EventObj newEv = new EventObj(obj.Id,
                                              String.valueOf(obj.get(titleField)),
                                              DateTime.valueOf(obj.get(startDateTimeField)),
                                              DateTime.valueOf(obj.get(endDateTimeField)),
                                              String.valueOf(obj.get(descriptionField)),
                                              String.valueOf(obj.get(contactNameField)),
                                              String.valueOf(obj.get(userField))
                                             );
                eventRecords.add(newEv);
            }
        }
        return eventRecords;
    }
    @AuraEnabled
    public static EventObj upsertEvents(String sEventObj, String sObjectName, String titleField, String startDateTimeField, String endDateTimeField, String descriptionField, String contactNameField, String userField){
        EventObj upsertingEvent = (EventObj)JSON.deserialize(sEventObj, EventObj.class);
        sObject newRecord = Schema.getGlobalDescribe().get(sObjectName).newSObject(); 
        if (upsertingEvent.Id != null && isAccessible(sObjectName,'Id')){
            newRecord.put('Id',upsertingEvent.Id);
        } 
        if (isAccessible(sObjectName,titleField)) {
            newRecord.put(titleField, upsertingEvent.title);
        }
        if (isAccessible(sObjectName,startDateTimeField)) {
            newRecord.put(startDateTimeField, upsertingEvent.startDateTime);
        }
        if (isAccessible(sObjectName,endDateTimeField)) {
            newRecord.put(endDateTimeField, upsertingEvent.endDateTime);
        }
        if (isAccessible(sObjectName,descriptionField)) {
            newRecord.put(descriptionField, upsertingEvent.description);
        }
        if (isAccessible(sObjectName,contactNameField)) {
            newRecord.put(contactNameField, upsertingEvent.contactName);
        }
        
        
        
        try {
            upsert newRecord;
            EventObj newEv = new EventObj(newRecord.Id,
                                  String.valueOf(newRecord.get(titleField)),
                                  DateTime.valueOf(newRecord.get(startDateTimeField)),
                                  DateTime.valueOf(newRecord.get(endDateTimeField)),
                                  String.valueOf(newRecord.get(descriptionField)),
                                  String.valueOf(newRecord.get(contactNameField)),
                                  String.valueOf(newRecord.get(userField))
                                 );
            return newEv;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
        
    }
    @AuraEnabled
    public static String deleteEvent(String eventId, String sObjectName, String titleField, String startDateTimeField, String endDateTimeField, String descriptionField, String userField){
        String q = 'SELECT Id,' + 
                titleField + ',' + 
                startDateTimeField + ',' +
                endDateTimeField + ',' +
                descriptionField + ',' +
                userField + ' FROM ' + 
                sObjectName + ' WHERE Id = \'' + eventId  + '\'';
        List<sObject> sObjectList = Database.query(q);
        try {
            if(isDeletable(sObjectName)) {
                delete sObjectList;
            }
            return eventId;
        } catch (Exception e) {
            System.debug(e.getMessage());
            return null;
        }
        
    }
    public class EventObj {
        @AuraEnabled
        public String Id {get;set;}
        @AuraEnabled
        public String title {get;set;}
        @AuraEnabled
        public DateTime startDateTime {get;set;}
        @AuraEnabled
        public DateTime endDateTime {get;set;}
        @AuraEnabled
        public String description {get;set;}
        @AuraEnabled
        public String owner {get;set;}
        @AuraEnabled
        public String contactName {get;set;}

        
        public EventObj(String i,String t, DateTime s, DateTime e, String d, String o, String contactName){
            this.Id = i;
            this.title = t;
            this.startDateTime = s;
            this.endDateTime = e;
            this.description = d;
            this.owner = o;
            this.contactName = contactName;
        }
        
    }
    public static Boolean isAccessible(String sObjectType, String fieldName){
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        Map<String, SObjectField> fields = schemaType.getDescribe().fields.getMap();
        DescribeFieldResult fieldDescribe = fields.get(fieldName).getDescribe();
        return fieldDescribe.isAccessible();
    }
    public static Boolean isAccessible(String sObjectType){
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        return schemaType.getDescribe().isAccessible();
    }
    public static Boolean isCreateable(String sObjectType){
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        return schemaType.getDescribe().isCreateable();
    }
    public static Boolean isDeletable(String sObjectType){
        SObjectType schemaType = Schema.getGlobalDescribe().get(sObjectType);
        return schemaType.getDescribe().isDeletable();
    }
}