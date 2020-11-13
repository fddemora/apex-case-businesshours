public with sharing class CaseBusinessHours {
    public static void newRecord(Case[] caseList){
        for(Case x : caseList){
            if(x.Days_Since__c == null) x.Days_Since__c	= 0;
        }
    }

    public static void updateRecord(Case[] oldList,Case[] newList){
      /*  for(Case x : oldList){
            System.debug(x.Days_Since__c);
        }
        for(Case x : newList){
            System.debug(x.Days_Since__c);
        }
        
        for(Integer i = 0; i < newList.size(); i++){
            System.debug(newList[i].LastModifiedDate.dayOfYear() + ' ' + datetime.now().dayOfYear());
        }
        */
        //final Integer = Datetime.now().dayOfYear()-newList
       
        Set<Id> idCaseSet = new Set<Id>();
        for(Case x : newList){
            idCaseSet.add(x.BusinessHoursId);
        }

        BusinessHours[] entries = [SELECT FridayStartTime,SaturdayStartTime,SundayStartTime,MondayStartTime,TuesdayStartTime,
        WednesdayStartTime,ThursdayStartTime FROM BusinessHours WHERE Id IN :idCaseSet];

        Integer[] counter = new Integer[entries.size()];

        for(Integer i = 0; i < entries.size(); i++){
            counter[i] = 0;
            if(entries[i].FridayStartTime != null) counter[i]++;
            if(entries[i].SaturdayStartTime != null) counter[i]++;
            if(entries[i].SundayStartTime != null) counter[i]++;
            if(entries[i].MondayStartTime != null) counter[i]++;
            if(entries[i].TuesdayStartTime != null) counter[i]++;
            if(entries[i].WednesdayStartTime != null) counter[i]++;
            if(entries[i].ThursdayStartTime != null) counter[i]++;
        }
      //  System.debug(counter[0]);

        for(Integer i = 0; i < oldList.size() && i < newList.size(); i++){
            if(oldList[i].Status == newList[i].Status) continue;
            final Integer numOfDays = Datetime.now().dayOfYear() - newList[i].LastModifiedDate.dayOfYear();
            Decimal numOfWeeks = (numOfDays / 7);
            numOfWeeks.round(System.RoundingMode.DOWN);
            final Integer daysLeft = (numOfDays - (numOfWeeks.intValue() * 7));
            final String day = System.now().format('EEEE');
            Integer remainder;
            if(day == 'Friday'){
                remainder = getDaysIfTodayIsFriday(entries, daysLeft, i);
            }
            System.debug(numOfDays + ' ' + numOfWeeks.intValue() + ' ' + counter[i] + ' ' + remainder);
            Integer open = counter[i]*numOfWeeks.intValue() + remainder;
            newList[i].Days_Since__c = open;
       //     Datetime dt = System.now();
       //     System.debug(dt.format('EEEE'));
        }

       // System.debug(entries.get('01m4W000000TPI9QAO').FridayStartTime);
    }

    private static Integer getDaysIfTodayIsFriday(BusinessHours[] entries, Integer daysLeft, Integer i){
        Integer counter = 0;
        if(daysLeft == 1 && (entries[i].ThursdayStartTime != null)) {
            counter++;
        }
        else if(daysLeft == 2){
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
        }
        else if(daysLeft == 3){
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
        }
        else if(daysLeft == 4){
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
        }
        else if(daysLeft == 5){
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
        }
        else if(daysLeft == 6){
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
        }
        return counter;
    }


    final Integer Monday = 1, TUESDAY = 2, WEDNESDAY = 3, THURSDAY = 4, FRIDAY = 5, SATURDAY = 6,
                SUNDAY = 7;

}
