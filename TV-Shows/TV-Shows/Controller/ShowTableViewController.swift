//
//  ShowTableViewController.swift
//  TV-Shows
//
//  Created by Siddhesh Mahadeshwar on 18/06/18.
//  Copyright © 2018 net.siddhesh. All rights reserved.
//

import UIKit
import SDWebImage

fileprivate let reuseIdentifier = "tableViewCell"
fileprivate let segueID = "detailSegueID"

fileprivate let height:CGFloat = 100.0

class ShowTableViewController: UITableViewController {
  var days:[Day] = []
  var nextDateCount:Int = 0
  
    override func viewDidLoad() {
      super.viewDidLoad()
      splitViewController?.delegate = self
      splitViewController?.preferredDisplayMode = .allVisible
      getShows(date: Date())
    }
  
  func getShows(date:Date) {
    let network = NetworkManager()
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    network.getShows(date: date) { [weak self] result in
      guard let strongSelf = self else { return }
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == segueID {
      var detailVC: DetailViewController!
      
      if let detailNavigationController = segue.destination as? UINavigationController {
        detailVC = detailNavigationController.topViewController as! DetailViewController
        detailVC.navigationItem.leftItemsSupplementBackButton = true
      } else {
        detailVC = segue.destination as! DetailViewController
      }
      
      guard let selectedRowIndexPath = tableView.indexPathForSelectedRow, let show = days[selectedRowIndexPath.section].show?[selectedRowIndexPath.row] else { return }
      detailVC.show = show
    }
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
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ShowTableViewCell
    let show = days[indexPath.section].show?[indexPath.row]
    cell.titleLabel.text = show?.name
    cell.timeLabel.text = show?.airTime
    cell.networkLabel.text = show?.network.name
    cell.accessoryView = UIImageView(image: UIImage(named: "BackArrow"))
    if let posterUrl = show?.poster?.medium {
        cell.postImageView.sd_setImage(with: URL(string: posterUrl), completed: nil)
    } else {
      cell.postImageView.backgroundColor = UIColor(red: 27/255, green: 28/255, blue: 29/255, alpha: 1)
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return height
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return days[section].name
  }
  
  override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let header = view as! UITableViewHeaderFooterView
    header.backgroundView?.backgroundColor = UIColor(red: 27/255, green: 28/255, blue: 29/255, alpha: 1)
    header.textLabel?.textColor = UIColor(red: 238/255, green: 154/255, blue: 55/255, alpha: 1)
  }
}

extension ShowTableViewController: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
    return true
  }
}
