/**************************************************************************************************
 *
 *  Trigger:   
 *
 *  @description : This is a trigger for Event object 
 *  @author : kajal@testcompany.com
 *  @date : 13/05/2019
 * 
 *************************************************************************************************/
trigger EventTrigger on Event (After insert) {
	//After Trigger
    if(Trigger.isAfter) {
        
        //After Insert Trigger
        if(Trigger.isInsert){
            EventTriggerHandler.handleAfterInsert(Trigger.new);
        }
    }
}