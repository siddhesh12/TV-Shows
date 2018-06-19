//
//  ShowApi.swift
//  TV-Shows
//
//  Created by Siddhesh Mahadeshwar on 17/06/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation

public enum ShowApi {
  case schedule(country: String, date: Date)
}

extension ShowApi: EndPointType {
  var baseURL: String {
    return environmentBaseURL+"/schedule"
  }
  
  var path: String {
    switch self {
    case .schedule(let country, let date):
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return "?country="+country+"&date="+formatter.string(from: date)
    }
  }
}
