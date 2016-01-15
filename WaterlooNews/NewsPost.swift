//
//  NewsPost.swift
//  WaterlooNews
//
//  Created by HeFeng on 2015-12-25.
//  Copyright © 2015 philipapa. All rights reserved.
//

import UIKit

class NewsPost {
  var title: String
  var url: NSURL
  var publishDate: NSDate
  var site: String
  static var dateFormatter: NSDateFormatter = {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
  }()
  static var displayDateFormatter: NSDateFormatter = {
    var formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd E"
    return formatter
  }()
  
  init(title: String, url: NSURL, publishDate: NSDate, site: String){
    self.title = title
    self.url = url
    self.publishDate = publishDate
    self.site = site
  }
  
  convenience init(title: String, url: String, publishDate: String, site: String){
    let actualUrl: NSURL = NSURL(string: url)!
    let actualDate: NSDate = NewsPost.dateFormatter.dateFromString(publishDate)!
    self.init(title: title, url: actualUrl, publishDate: actualDate, site: site)
  }
}