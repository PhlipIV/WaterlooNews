//
//  NewsPostTableViewCell.swift
//  WaterlooNews
//
//  Created by HeFeng on 2015-12-25.
//  Copyright © 2015 philipapa. All rights reserved.
//

import UIKit

class NewsPostTableViewCell: UITableViewCell {

  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var site: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
