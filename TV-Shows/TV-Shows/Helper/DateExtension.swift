//
//  DateExtension.swift
//  TV-Shows
//
//  Created by Siddhesh Mahadeshwar on 18/06/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation

extension Date {
  func dayOfWeek() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    return dateFormatter.string(from: self)
  }
  
  func asString(style: DateFormatter.Style) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = style
    return dateFormatter.string(from: self)
  }
}
