//
//  Day.swift
//  TV-Shows
//
//  Created by Siddhesh Mahadeshwar on 18/06/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Day {
  var name:String
  var date:String
  var show:[Show]?
  
  static func get(rawArray: [JSON], date:Date) -> Day {
    return Day(name: date.dayOfWeek(),
               date: date.asString(style: .medium),
               show: Show.all(rawArray))
  }
}

struct Show {
  var id: Int
  var name:String
  var airTime:String
  var airDate:String
  var seasonNumber:Int?
  var episodeNumber:Int?
  var summary:String?
  var cast:String?
  var genres:String?
  var duration:Int?
  var network:Network
  var poster:Poster?
  
  static func all(_ rawArray: [JSON]) -> [Show] {
    var shows =  [Show]()
    rawArray.forEach { dictionary in
      guard let id = dictionary["id"].int,
        let name = dictionary["show"].dictionary?["name"]?.string,
        let airTime = dictionary["airtime"].string,
        let airDate = dictionary["airdate"].string,
        let network = Network.get(networkRawDictionary: dictionary["show"].dictionary?["network"]?.dictionary) else {
          return
      }
      
      shows.append(Show(id: id,
                        name: name,
                        airTime: airTime,
                        airDate: airDate,
                        seasonNumber: dictionary["season"].int,
                        episodeNumber:dictionary["number"].int ,
                        summary: dictionary["show"].dictionary?["summary"]?.string,
                        cast: dictionary["cast"].string,
                        genres: dictionary["show"].dictionary?["genres"]?.array?.compactMap({$0.string}).joined(separator: ", "),
                        duration: dictionary["show"].dictionary?["runtime"]?.int,
                        network: network,
                        poster: Poster.get(imageRawDictionary: dictionary["show"].dictionary?["image"]?.dictionary)))
    }
    return shows.sorted(by: {$0.airTime < $1.airTime})
  }
}

struct Poster {
  var medium:String
  var original:String
  
  static func get(imageRawDictionary:[String: JSON]?) -> Poster? {
    guard let dictionary = imageRawDictionary,
      let medium = dictionary["medium"]?.string,
      let original = dictionary["original"]?.string else {
        return nil
    }
    
    return Poster(medium: medium, original: original)
  }
}

struct Network {
  var id: Int
  var name:String
  var country:Country?
  
  static func get(networkRawDictionary:[String: JSON]?) -> Network? {
    guard let dictionary = networkRawDictionary,
      let id = dictionary["id"]?.int,
      let name = dictionary["name"]?.string else {
        return nil
    }
    
    return Network(id: id, name: name, country: Country.get(countryRawDictionary: dictionary["country"]?.dictionary))
  }
}

struct Country {
  var name:String
  var code:String
  var timeZone:String
  
  static func get(countryRawDictionary:[String: JSON]?) -> Country? {
    guard let dictionary = countryRawDictionary,
      let name = dictionary["name"]?.string,
      let code = dictionary["code"]?.string,
      let timeZone = dictionary["timezone"]?.string else {
        return nil
    }
    return Country(name: name, code: code, timeZone: timeZone)
  }
}
