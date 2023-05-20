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
