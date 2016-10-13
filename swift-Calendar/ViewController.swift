//
//  ViewController.swift
//  swift-Calendar
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let scale = UIScreen.mainScreen().scale
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        
        let calendarView = MJ_CalendarView(frame: CGRectMake(0, 0, self.view.frame.size.width-80, self.view.frame.size.width+80-90), collectionViewLayout: layout)
        calendarView.center = CGPointMake(self.view.center.x, self.view.center.y-20*scale)
//        calendarView.currentDateStr = "20161012"
        calendarView.registerArr = ["20160909","20161013","20160908"]
        calendarView.totalPoint = "9999"
        self.view.addSubview(calendarView)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

