public with sharing class CaseBusinessHours {
    
    public static void newRecord(Case[] caseList){
        for(Case x : caseList){
            if(x.Days_Since__c == null) x.Days_Since__c	= 0;
        }
    }

    public static void updateRecord(Case[] oldList,Case[] newList){
   
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
            } else if(day == 'Saturday'){
                remainder = getDaysIfTodayIsSaturday(entries, daysLeft, i);
            } else if(day == 'Sunday'){
                remainder = getDaysIfTodayIsSunday(entries, daysLeft, i);
            } else if(day == 'Monday'){
                remainder = getDaysIfTodayIsMonday(entries, daysLeft, i);
            } else if(day == 'Tuesday'){
                remainder = getDaysIfTodayIsTuesday(entries, daysLeft, i);
            } else if(day == 'Wednesday') {
                remainder = getDaysIfTodayIsWednesday(entries, daysLeft, i);
            } else if(day == 'Thursday') {
                remainder = getDaysIfTodayIsThursday(entries, daysLeft, i);
            }

            Integer open = counter[i]*numOfWeeks.intValue() + remainder;
            newList[i].Days_Since__c = open;
        }

    }

    private static Integer getDaysIfTodayIsThursday(BusinessHours[] entries, Integer daysLeft, Integer i){
        Integer counter = 0;
        if(daysLeft == 1 && (entries[i].WednesdayStartTime != null)) {
            counter++;
        }
        else if(daysLeft == 2){
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
        }
        else if(daysLeft == 3){
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
        }
        else if(daysLeft == 4){
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
        }
        else if(daysLeft == 5){
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
        }
        else if(daysLeft == 6){
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
        }
        return counter;
    }

    private static Integer getDaysIfTodayIsWednesday(BusinessHours[] entries, Integer daysLeft, Integer i){
        Integer counter = 0;
        if(daysLeft == 1 && (entries[i].TuesdayStartTime != null)) {
            counter++;
        }
        else if(daysLeft == 2){
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
        }
        else if(daysLeft == 3){
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
        }
        else if(daysLeft == 4){
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
        }
        else if(daysLeft == 5){
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
        }
        else if(daysLeft == 6){
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
        }
        return counter;
    }

    private static Integer getDaysIfTodayIsTuesday(BusinessHours[] entries, Integer daysLeft, Integer i){
        Integer counter = 0;
        if(daysLeft == 1 && (entries[i].MondayStartTime != null)) {
            counter++;
        }
        else if(daysLeft == 2){
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
        }
        else if(daysLeft == 3){
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
        }
        else if(daysLeft == 4){
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
        }
        else if(daysLeft == 5){
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
        }
        else if(daysLeft == 6){
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
        }
        return counter;
    }

    private static Integer getDaysIfTodayIsMonday(BusinessHours[] entries, Integer daysLeft, Integer i){
        Integer counter = 0;
        if(daysLeft == 1 && (entries[i].SundayStartTime != null)) {
            counter++;
        }
        else if(daysLeft == 2){
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
        }
        else if(daysLeft == 3){
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
        }
        else if(daysLeft == 4){
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
        }
        else if(daysLeft == 5){
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
        }
        else if(daysLeft == 6){
            if(entries[i].SundayStartTime != null) counter++;
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
        }
        return counter;
    }

    private static Integer getDaysIfTodayIsSunday(BusinessHours[] entries, Integer daysLeft, Integer i){
        Integer counter = 0;
        if(daysLeft == 1 && (entries[i].SaturdayStartTime != null)) {
            counter++;
        }
        else if(daysLeft == 2){
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
        }
        else if(daysLeft == 3){
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
        }
        else if(daysLeft == 4){
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
        }
        else if(daysLeft == 5){
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
        }
        else if(daysLeft == 6){
            if(entries[i].SaturdayStartTime != null) counter++;
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
        }
        return counter;
    }

    private static Integer getDaysIfTodayIsSaturday(BusinessHours[] entries, Integer daysLeft, Integer i){
        Integer counter = 0;
        if(daysLeft == 1 && (entries[i].FridayStartTime != null)) {
            counter++;
        }
        else if(daysLeft == 2){
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
        }
        else if(daysLeft == 3){
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
        }
        else if(daysLeft == 4){
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
        }
        else if(daysLeft == 5){
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
        }
        else if(daysLeft == 6){
            if(entries[i].FridayStartTime != null) counter++;
            if(entries[i].ThursdayStartTime != null) counter++;
            if(entries[i].WednesdayStartTime != null) counter++;
            if(entries[i].TuesdayStartTime != null) counter++;
            if(entries[i].MondayStartTime != null) counter++;
            if(entries[i].SundayStartTime != null) counter++;
        }
        return counter;
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
}
