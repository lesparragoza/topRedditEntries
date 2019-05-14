//
//  Date+format.swift
//  TopRedditEntries
//
//  Created by Luis Esparragoza Home on 13/05/2019.
//  Copyright © 2019 Luis Esparragoza Home. All rights reserved.
//

import Foundation

extension Date {
        
    func getTimeWith(_ timeUnits: Double) -> Int {
        return Int(self.timeIntervalSinceNow / timeUnits) * (self.timeIntervalSinceNow < 0 ? -1 : 1)
    }
    
    func getDateSpecifications() -> String {
        if self.getTimeWith(60) < 1 {
            return "Just now"
        } else if self.getTimeWith(60) < 60 {
            return timePassedDescription(timePassed: self.getTimeWith(60), timeComponent: " minute")
        } else if self.getTimeWith(3600) < 24 {
            return timePassedDescription(timePassed: self.getTimeWith(3600), timeComponent: " hour")
        } else if self.getTimeWith(86400) < 8 {
            return timePassedDescription(timePassed: self.getTimeWith(86400), timeComponent: " day")
        } else if self.getTimeWith(648000) < 4 {
            return timePassedDescription(timePassed: self.getTimeWith(648000), timeComponent: " week")
        } else if self.getTimeWith(2592000) < 12 {
            return timePassedDescription(timePassed: self.getTimeWith(2592000), timeComponent: " month")
        } else {
            return timePassedDescription(timePassed: self.getTimeWith(2592000), timeComponent: " year")
        }
    }
    
    func timePassedDescription(timePassed timeInNumbers: Int, timeComponent: String) -> String {
        let agoText = timeInNumbers == 1 ? " ago" : "s ago"
        return "\(timeInNumbers)" + "\(timeComponent + agoText)"
    }
    
}
