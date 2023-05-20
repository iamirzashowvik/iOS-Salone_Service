//
//  Alert.swift
//  ecommerce
//
//  Created by Mirza Showvik on 19/5/23.
//

import Foundation

class AlertClassX {
    static let showAlertMsg = Notification.Name("ALERT_MSG")
    
    init() {
        alertNow() // simulate showing the alert in 2 secs
    }
    
    func alertNow() {
        //.... do calculations
        // then send a message to show the alert in the Views "listening" for it
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            NotificationCenter.default.post(name: AlertClassX.showAlertMsg, object: nil)
        }
    }
}

func calcTimeSince(date:Date)->String{
    let minutes=Int(-date.timeIntervalSinceNow)/60
    let hours=minutes/60
    let days=hours/24
    if minutes < 120 {
        return "\(minutes) minutes ago";
    }
    else if minutes>=120 && hours < 48 {
        return "\(hours) hours ago";
    }
    else{
        return "\(days) days ago";
    }
}

func isSameDay(date1: Date, date2: Date) -> Bool {
    if dateToString(date: date1) == dateToString(date: date2){
        return true
    } else {
        return false
    }
}

func dateToString(date:Date)->String{
    let formatter = DateFormatter()
    // initially set the format based on your datepicker date / server String
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    let myString = formatter.string(from: date) // string purpose I add here
    // convert your string to date
    let yourDate = formatter.date(from: myString)
    //then again set the date format whhich type of output you need
    formatter.dateFormat = "dd-MMM-yyyy"
    // again convert your date to string
    let myStringDate = formatter.string(from: yourDate!)
    print(myStringDate)
    return myStringDate;
}
