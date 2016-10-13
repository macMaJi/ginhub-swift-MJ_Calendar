//
//  MJ_CalendarCell.swift
//  swift-Calendar
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class MJ_CalendarCell: UICollectionViewCell {
    var numLabel:UILabel?
    var selectImageView: UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.numLabel = UILabel(frame: CGRectMake(0, 0, 28, 28))
        self.numLabel?.textAlignment = .Center
//        numLabel?.center = self.center
        numLabel?.textColor = UIColor.lightGrayColor()
        
        self.selectImageView = UIImageView(frame: CGRectMake(19, 17, 8, 8))
//        self.selectImageView?.backgroundColor = UIColor.blueColor()
        self.selectImageView?.image = UIImage(named: "jk_icon_duigou")
        self.selectImageView?.hidden = true
        self.addSubview(numLabel!)
        self.addSubview(selectImageView!)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
