//
//  WaterlooNewsViewController.swift
//  WaterlooNews
//
//  Created by HeFeng on 2015-12-25.
//  Copyright © 2015 philipapa. All rights reserved.
//

import UIKit
import SafariServices

class WaterlooNewsViewController: UIViewController {

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  private let newsRequest = NewsRequest()
  private var newsPosts: [NewsPost]? {
    didSet{
      self.tableView.reloadData()
    }
  }
  private var originalNewsPosts: [NewsPost]?
  private var refreshControl:UIRefreshControl!
  var sites:[String]?
  
  enum State {
    case DefaultMode
    case SearchMode
  }
  
  var state: State = .DefaultMode{
    didSet {
      switch (state) {
      case .DefaultMode:
        self.newsPosts = self.originalNewsPosts
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = false
        self.navigationController!.setNavigationBarHidden(false, animated: true)
      case .SearchMode:
        originalNewsPosts = newsPosts
        let searchText = searchBar?.text ?? ""
        searchBar.setShowsCancelButton(true, animated: true)
        newsPosts = searchNews(searchText)
        self.navigationController!.setNavigationBarHidden(true, animated: true)
      }
    }
  }
  
  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.delegate = self
    searchBar.delegate = self
    
    self.refreshControl = UIRefreshControl()
    self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
    self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    self.tableView.addSubview(refreshControl)
    
    tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.estimatedRowHeight = 160
    
  }
  
  override func viewWillAppear(animated: Bool) {
    
    
    let vc = tabBarController?.viewControllers![1] as! UINavigationController
    let newsFeedVC = vc.topViewController as! NewsFeedViewController
    let newFeedSites = newsFeedVC.newsFeedSite
    var selection = newsFeedVC.newsFeedSelection
    
    self.sites = newFeedSites.filter{
      return selection[newFeedSites.indexOf($0)!]
    }
    
    newsRequest.requestForNews(sites){
      results, error in
      self.newsPosts = results
      self.tableView.reloadData()
    }
  }
  
  func refresh(sender:AnyObject){
    self.refreshControl.endRefreshing()
    newsRequest.requestForNews(sites){
      results, error in
      
      self.newsPosts = results
      self.tableView.reloadData()
      
    }
  }
  
  func searchNews(searchText: String) -> [NewsPost]? {
    if searchText == "" {
      return originalNewsPosts
    }
    
    return originalNewsPosts?.filter(){
      let newsPost = $0
      if ( newsPost.title.lowercaseString.rangeOfString(searchText.lowercaseString) != nil ){
        return true
      }
      return false
    }
  }
}

extension WaterlooNewsViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsPostTableViewCell
    cell.title!.text = newsPosts![indexPath.row].title
    cell.date!.text = NewsPost.displayDateFormatter.stringFromDate(newsPosts![indexPath.row].publishDate)
    cell.site!.text = newsPosts![indexPath.row].site
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return newsPosts?.count ?? 0
  }
  
}

extension WaterlooNewsViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let newsPost = newsPosts![indexPath.row]
    let webViewController = SFSafariViewController(URL: newsPost.url, entersReaderIfAvailable: true)
    webViewController.delegate = self
    presentViewController(webViewController, animated: true, completion: nil)
  }
}

extension WaterlooNewsViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(controller: SFSafariViewController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
}

extension WaterlooNewsViewController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    state = .SearchMode
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    state = .DefaultMode
  }
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    newsPosts = searchNews(searchText)
  }
}
