//
//  ShowTableViewController.swift
//  TV-Shows
//
//  Created by Siddhesh Mahadeshwar on 18/06/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit

protocol ShowTableViewControllerDelegate: class {
  func showSelected(_ show: Show)
}

class ShowTableViewController: UITableViewController {
  weak var delegate: ShowTableViewControllerDelegate?
  private var collapseDetailViewController = true
  var days:[Day] = []
  var nextDateCount:Int = 0
  
    override func viewDidLoad() {
      super.viewDidLoad()
//      splitViewController?.delegate = self
      splitViewController?.preferredDisplayMode = .allVisible
      getShows(date: Date())
    }
  
  func getShows(date:Date) {
    let network = NetworkManager()
    network.getShows(date: date) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let day):
        strongSelf.days.append(day)
        strongSelf.tableView.reloadData()
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func getNextDate() -> Date {
    nextDateCount += 1
    return Calendar.current.date(byAdding: .day, value: nextDateCount, to: Date())!
  }
}

extension ShowTableViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return days.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return days[section].show?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.section == days.count - 1,
      let count = days[indexPath.section].show?.count,
      indexPath.row == count - 1,
      nextDateCount < 7 {
      getShows(date: getNextDate())
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! ShowTableViewCell
    let show = days[indexPath.section].show?[indexPath.row]
    cell.titleLabel.text = show?.name
    cell.timeLabel.text = show?.airTime
    cell.networkLabel.text = show?.network.name
    cell.accessoryView = UIImageView(image: UIImage(named: "BackArrow"))
    cell.postImageView.image = UIImage(named: "1")
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return days[section].name
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.backgroundView?.backgroundColor = UIColor(red: 27/255, green: 28/255, blue: 29/255, alpha: 1)
    header.textLabel?.textColor = UIColor(red: 238/255, green: 154/255, blue: 55/255, alpha: 1)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let show = days[indexPath.section].show?[indexPath.row] else { return }
    collapseDetailViewController = false
    delegate?.showSelected(show)
    if let detailViewController = delegate as? DetailViewController,
      let detailNavigationController = detailViewController.navigationController {
      splitViewController?.showDetailViewController(detailNavigationController, sender: nil)
    }
  }
}

extension ShowTableViewController: UISplitViewControllerDelegate {
  
}
