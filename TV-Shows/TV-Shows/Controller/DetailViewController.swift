//
//  DetailViewController.swift
//  TV-Shows
//
//  Created by Siddhesh Mahadeshwar on 18/06/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  var show: Show!

  @IBOutlet weak var summaryLabel: UILabel!
  @IBOutlet weak var seasonLabel: UILabel!
  @IBOutlet weak var episodeLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  func loadValues() {
    if let summary = show.summary {
    summaryLabel.text = summary.htmlToString
    }
    seasonLabel.text = show.seasonNumber != nil ? "\(show.seasonNumber!)" : ""
    episodeLabel.text = show.episodeNumber != nil ? "\(show.episodeNumber!)" : ""
    if let genres = show.genres {
      genreLabel.text = genres.isEmpty ? "-" : genres
    }
    durationLabel.text = show.duration != nil ? "\(show.duration!) Mins" : ""
  }
}

extension DetailViewController: ShowTableViewControllerDelegate {
  func showSelected(_ show: Show) {
    self.show = show
    loadValues()
  }
}

//https://stackoverflow.com/questions/37048759/swift-display-html-data-in-a-label-or-textview
extension String {
  var htmlToAttributedString: NSAttributedString? {
    guard let data = data(using: .utf8) else { return NSAttributedString() }
    do {
      return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
    } catch {
      return NSAttributedString()
    }
  }
  var htmlToString: String {
    return htmlToAttributedString?.string ?? ""
  }
}

