//
//  File.swift
//  WaterlooNews
//
//  Created by HeFeng on 2015-12-25.
//  Copyright © 2015 philipapa. All rights reserved.
//

import Foundation

class NewsRequest {
  
  let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
  //let sites: [String] = ["News", "Engineering", "physics-astronomy"]
  var numberOfSitesWithNewsLoaded: Int = 0
  
  func requestForNews(sites: [String]? ,completion : (results: [NewsPost]?, error : NSError?) -> Void) {
    numberOfSitesWithNewsLoaded = 0;
    var aggregatedNews = [NewsPost]()
    if let sites = sites{
      for site in sites {
        let searchUrl = getSearchUrl(site)
        let searchRequest = NSURLRequest(URL: searchUrl!)
        let task = session.dataTaskWithRequest(searchRequest){
          (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
          if error != nil {
            completion(results: nil, error: error)
            return
          }
          
          var resultDictionary: NSDictionary!
          do {
            resultDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0)) as? NSDictionary
          } catch let error as NSError {
            completion(results: nil, error: error)
            return
          }
          
          switch (resultDictionary["meta"]!["status"] as! Int) {
          case 200:
            print("Result processed ok")
          default:
            let apiError = NSError(domain: "NewsRequestError", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "Uknown API response"])
            completion(results: nil, error: apiError)
            return
          }
          
          let newsReceived = resultDictionary["data"] as! [NSDictionary]
          
          let newsPosts : [NewsPost] = newsReceived.map {
            individualNews in
            
            let title = individualNews["title"] as! String
            let url = individualNews["link"] as! String
            let publishDate = individualNews["published"] as! String
            
            let newsPost = NewsPost(title: title, url: url, publishDate: publishDate, site: site)
            
            return newsPost
          }
          
          aggregatedNews += newsPosts
          self.numberOfSitesWithNewsLoaded++;
          if (self.numberOfSitesWithNewsLoaded == sites.count){
            aggregatedNews.sortInPlace{
              (post1, post2) -> Bool in
              let compareResult = post1.publishDate.compare(post2.publishDate)
              switch (compareResult){
              case NSComparisonResult.OrderedAscending:
                return false
              default:
                return true
              }
            }
            
            completion(results: aggregatedNews, error: nil)
          }
        }
        task .resume()
      }
    }
    
  }
  
  private func getSearchUrl(site: String) -> NSURL? {
    let URLString = "https://api.uwaterloo.ca/v2/news/\(site).json?key=0c9e72cc9a9f79be6a0104760c9f568a"
    return NSURL(string: URLString)
  }
  
}