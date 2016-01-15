//
//  NewsFeedLayout.swift
//  WaterlooNews
//
//  Created by HeFeng on 2015-12-26.
//  Copyright © 2015 philipapa. All rights reserved.
//

import UIKit

class NewsFeedLayout: UICollectionViewLayout {
  
  var numberOfColumns = 3
  var cellPadding: CGFloat = 6.0
  
  private var cache = [UICollectionViewLayoutAttributes]()
  
  private var contentHeight: CGFloat = 0.0
  private var contentWidth: CGFloat {
    let insets = collectionView!.contentInset
    return CGRectGetWidth(collectionView!.bounds) - (insets.left + insets.right)
  }
  
  override func collectionViewContentSize() -> CGSize {
    return CGSize(width: 200, height: 300)
  }
}
