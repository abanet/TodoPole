//
//  Date+Extension.swift
//  TodoPole
//
//  Created by Alberto Banet Masa on 4/4/17.
//  Copyright © 2017 Alberto Banet. All rights reserved.
//

import Foundation

extension Date {
  func timeAgoDisplay() -> String {
    let secondsAgo = Int(Date().timeIntervalSince(self))
    print("fecha para ver intervalo: \(self)")
    print("date hoy: \(Date())")
    
    let minute  = 60
    let hour    = 60 * minute
    let day     = 24 * hour
    let week    = 7 * day
    let month   = 4 * week
    let year    = 12 * month
    
    if secondsAgo < minute {
      return (secondsAgo == 1) ? "\(secondsAgo) second ago" : "\(secondsAgo) seconds ago"
    } else if secondsAgo < hour {
      let minutesSince = Int(secondsAgo / minute)
      return (minutesSince == 1) ? "\(minutesSince) minute ago" : "\(minutesSince) minutes ago"
    } else if secondsAgo < day {
      let hoursSince = Int(secondsAgo / hour)
      return  (hoursSince == 1) ? "\(hoursSince) hour ago" : "\(hoursSince) hours ago"
    } else if secondsAgo < week {
      let daysSince = Int(secondsAgo / day)
      return  (daysSince == 1) ? "\(daysSince) day ago" : "\(daysSince) days ago"
    } else if secondsAgo < month {
      let weeksSince = Int(secondsAgo / week)
      return (weeksSince == 1) ? "\(weeksSince) week ago" : "\(weeksSince) weeks ago"
    } else if secondsAgo < year {
      let monthsSince = Int(secondsAgo / month)
      return (monthsSince == 1) ? "\(monthsSince) month ago" : "\(monthsSince) months ago"
    }
    let yearsSince = Int(secondsAgo / year)
    return (yearsSince == 1) ? "\(yearsSince) year ago" : "\(yearsSince) years ago"
  }
}
