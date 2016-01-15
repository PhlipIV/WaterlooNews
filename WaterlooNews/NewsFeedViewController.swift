//
//  NewsFeedViewController.swift
//  WaterlooNews
//
//  Created by HeFeng on 2015-12-26.
//  Copyright © 2015 philipapa. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController {

  let newsFeedLogos: [UIImage?] = [UIImage(named: "news"), UIImage(named: "math"), UIImage(named: "engineering"), UIImage(named: "science")]
  let unselectedImage: [UIImage?] = [UIImage(named: "newsUnselected"), UIImage(named: "mathUnselected"), UIImage(named: "engineeringUnselected"), UIImage(named: "scienceUnselected")]
  let newsFeedLabels: [String] = ["Waterloo News", "Math", "Engineering", "Science"]
  var newsFeedSite = ["news", "math", "engineering", "science"]
  var newsFeedSelection = [true, false, true, true]
  var cellWidth: CGFloat?
  let numberOfColumns = CGFloat(3)

  @IBOutlet weak var collectionView: UICollectionView!
  

    override func viewDidLoad() {
      super.viewDidLoad()
      
      collectionView.dataSource = self
      collectionView.delegate = self
      collectionView!.contentInset = UIEdgeInsets(top: 0, left: 30, bottom: 10, right: 30)
      collectionView.allowsMultipleSelection = true;
      let insets = collectionView!.contentInset
      cellWidth =  (CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right))/numberOfColumns/CGFloat(2)
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension NewsFeedViewController: UICollectionViewDataSource {
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return newsFeedLogos.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsFeedCell", forIndexPath: indexPath) as! NewsFeedCollectionViewCell
    
    cell.newsFeedLogo.image = unselectedImage[indexPath.row]
    cell.newsFeedLogo.highlightedImage = newsFeedLogos[indexPath.row]
    cell.NewsFeedLabel.text = newsFeedLabels[indexPath.row]
    cell.newsFeedLogo.layer.cornerRadius = cellWidth! / 2
    cell.newsFeedLogo.clipsToBounds = true

    cell.newsFeedLogo.highlighted = newsFeedSelection[indexPath.row]
    
    return cell
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
}

extension NewsFeedViewController: UICollectionViewDelegate {
  func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    newsFeedSelection[indexPath.row] = !newsFeedSelection[indexPath.row]
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! NewsFeedCollectionViewCell
    cell.newsFeedLogo.highlighted = newsFeedSelection[indexPath.row]
  }
  func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    newsFeedSelection[indexPath.row] = !newsFeedSelection[indexPath.row]
    let cell = collectionView.cellForItemAtIndexPath(indexPath) as! NewsFeedCollectionViewCell
    cell.newsFeedLogo.highlighted = newsFeedSelection[indexPath.row]
  }
}


extension NewsFeedViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake(cellWidth!, cellWidth! + 50)
  }
  
  

}