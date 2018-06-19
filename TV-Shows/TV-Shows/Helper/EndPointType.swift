//
//  EndPointType.swift
//  TV-Shows
//
//  Created by Siddhesh Mahadeshwar on 17/06/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation

protocol EndPointType {
  var baseURL: String { get }
  var environmentBaseURL: String { get }
  var path: String { get }
}

extension EndPointType {
  var environmentBaseURL : String {
    switch NetworkManager.environment {
    case .production: return "https://api.tvmaze.com"
    case .qa: return "http://qa.tvmaze.com/schedule"
    case .staging: return "http://staging.tvmaze.com/schedule"
    }
  }
}
