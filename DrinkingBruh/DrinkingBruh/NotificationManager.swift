//
//  NotificationManager.swift
//  DrinkingBruh
//
//  Created by Cynthia  Ibarra on 4/14/17.
//  Copyright © 2017 Cynthia  Ibarra. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


class NotificationManager {
    
    static func eventNotification (date:String, eventTitle:String, eventID:String) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d yyyy, hh:mm a"
        let date:Date = dateFormatter.date(from: date)!
        let timeInterval = date.timeIntervalSinceNow
        
        let content = UNMutableNotificationContent()
        content.body = "\(eventTitle) is happening right now."
        content.sound = UNNotificationSound.default()
        
        print(timeInterval)
        if timeInterval > 0.0 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
            let request = UNNotificationRequest(identifier: eventID, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
