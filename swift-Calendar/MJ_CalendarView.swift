//
//  MJ_CalendarView.swift
//  swift-Calendar
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit
//我就是测试一下改了没有------------------------
class MJ_CalendarView: UICollectionView ,UICollectionViewDelegate ,UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    var year:Int = 0              //当前的时间
    var searchYear:Int = 0        //记录用户选择的时间
    var month:Int = 0
    var searchmonth: Int = 0
    var day: Int = 0
    var searchDay: Int = 0
    
    
    var currentDateStr: String?   //当前时间的字符串"20161012"
    
    var nextButton: UIButton?     //记录当前的下一个按钮
    
    var totalPoint: String?{      //签到获得的总积分
        didSet{
            //添加footview
            footView?.removeFromSuperview()
            let width = frame.size.width
            footView = UIView(frame: CGRectMake(0, width+10, width, 90))
            //设置签到获得积分的label
            let totalLabel = UILabel(frame: CGRectMake(0, 10, width, 35))
            totalLabel.textAlignment = .Center
            totalLabel.text = String(format: "签到共获得积分  %@",totalPoint ?? "")
            totalLabel.textColor = UIColor.redColor()
            totalLabel.font = UIFont.systemFontOfSize(20)
            footView?.addSubview(totalLabel)
            //        footView?.backgroundColor=UIColor.redColor()
            self.addSubview(footView!)
        }
    }
    
    var daysOfMonth: Int = 0        //一个月有多少天
    var searchDaysOfMonth: Int = 0
    var cellWidth: CGFloat = 0
    var headerView: UIView?
    var footView: UIView?
    //签过到的时间数组
    var registerArr:[String]?
    //保存请求过得年月
    var yearYueArr:[String]?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        /**
         添加手势
         */
        //向左滑动
        let collectionViewSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MJ_CalendarView.next))
        collectionViewSwipeLeft.direction = .Left
        self.addGestureRecognizer(collectionViewSwipeLeft)
        //向右滑动
        let collectionViewSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MJ_CalendarView.pre))
        collectionViewSwipeRight.direction = .Right
        self.addGestureRecognizer(collectionViewSwipeRight)
        
        self.registerClass(MJ_CalendarCell.self, forCellWithReuseIdentifier: "MJ_cell")
        self.scrollEnabled = false
        delegate = self
        backgroundColor = UIColor.whiteColor()
        dataSource = self
        year = MJ_Calendar.getYear()
        searchYear = year
        
        month = MJ_Calendar.getMonth()
        searchmonth = month
        
        day = MJ_Calendar.getDay()
        searchDay = day
        //添加哪天签到啦
        registerArr = ["20160909","20161018","20160908"]
        //可以发送网络请求,也可以存到本地去取
        
        //返回一个月有多少天
        daysOfMonth = MJ_Calendar.getDaysOfMonth(year, month: month)
        searchDaysOfMonth = daysOfMonth
        
        cellWidth = (frame.size.width-5*8)/7
        self.layer.cornerRadius = 8
        layer.masksToBounds = true
        totalPoint = "0"
//        TotalPoint(totalPoint!)
        buildHeaderView(frame.size.width)
    }
    func buildHeaderView(width:CGFloat){
        var arr = ["日","一","二","三","四","五","六"]
        headerView?.removeFromSuperview()
        headerView = UIView(frame: CGRectMake(0, 0, width, 100))
        let dateLabel = UILabel(frame: CGRectMake(0, 0, 130, 30))
        dateLabel.textAlignment = .Center
        dateLabel.textColor = UIColor.brownColor()
        dateLabel.center = CGPointMake(width/2, 30)
        dateLabel.font = UIFont.boldSystemFontOfSize(18)
        let tempYue = String(format: "%.2d月", searchmonth)
        dateLabel.text = "\(searchYear)年\(tempYue)"
        headerView?.addSubview(dateLabel)
        
        let nextBtn = UIButton(type: .Custom)
        self.nextButton = nextBtn
        let maxX = CGRectGetMaxX(dateLabel.frame)
        let minX = CGRectGetMinX(dateLabel.frame)
        nextButton?.frame = CGRectMake(maxX, 20, 30, 20)
        nextButton?.addTarget(self, action: #selector(MJ_CalendarView.next), forControlEvents: .TouchUpInside)
        nextButton?.setImage(UIImage(named: "next.png"), forState: .Normal)
        headerView?.addSubview(nextButton!)
        
        let preButton = UIButton(type: .Custom)
        preButton.frame = CGRectMake(minX-30, 20, 30, 20)
        preButton.addTarget(self, action: #selector(MJ_CalendarView.pre), forControlEvents: .TouchUpInside)
        preButton.setImage(UIImage(named: "pre.png"), forState: .Normal)
        headerView?.addSubview(preButton)
        
        
        let grayView = UIView(frame: CGRectMake(10, 60, width-20, 35))
        grayView.backgroundColor = UIColor.grayColor()
        grayView.layer.cornerRadius = 18
        grayView.layer.masksToBounds = true
        headerView?.addSubview(grayView)
        let labelWidth = (width-35)/7
        for i in 0..<7 {
            let label = UILabel(frame: CGRectMake(CGFloat(i)*labelWidth+5, 0, labelWidth, 30))
            label.text = arr[i]
            label.textAlignment = .Center
            label.textColor = UIColor.redColor()
            label.font = UIFont.systemFontOfSize(16)
            grayView.addSubview(label)
        }
        self.addSubview(headerView!)
        
    }
    
    //下一月
    func next(){
        if searchmonth == 12 {
            searchmonth = 1
            searchYear += 1
        }else{
            searchmonth += 1
        }
//        let yearMonth = String
        searchDaysOfMonth = MJ_Calendar.getDaysOfMonth(searchYear, month: searchmonth)
        buildHeaderView(frame.size.width)
        UIView.transitionWithView(self, duration: 0.25, options: .TransitionCrossDissolve, animations: {
            self.reloadData()
            }, completion: nil)
    }
    //上一月
    func pre(){
//        nextButton?.hidden = false
        if searchmonth == 1 {
            searchmonth = 12
            searchYear -= 1
        }else{
            searchmonth -= 1
        }
        searchDaysOfMonth = MJ_Calendar.getDaysOfMonth(searchYear, month: searchmonth)
        buildHeaderView(frame.size.width)
        //动画
        UIView.transitionWithView(self, duration: 0.25, options: .TransitionCrossDissolve, animations: {
            self.reloadData()
            }, completion: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //数据源方法
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //定义每个UICollectionCell 的大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(cellWidth, cellWidth-10)
    }
    //定义每个UICollectionView 的 margin
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(100, 17.5, 1, 17.5)
    }
    //主要方法
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:MJ_CalendarCell = collectionView.dequeueReusableCellWithReuseIdentifier("MJ_cell", forIndexPath: indexPath) as! MJ_CalendarCell
        cell.selectImageView?.hidden = true
//        cell.backgroundColor = UIColor.yellowColor()
                                                  //获得某个月的第一天是星期几
        let dateNum = indexPath.row - MJ_Calendar.getWeekOfFirstDayOfMonthWithYear(searchYear, month: searchmonth)+1
        /*
         统一日期设置
         */
        //月内label
        if dateNum>=1 && indexPath.row<searchDaysOfMonth+MJ_Calendar.getWeekOfFirstDayOfMonthWithYear(searchYear, month: searchmonth) {
            cell.numLabel?.text = String(dateNum)
            cell.numLabel?.textColor = UIColor.blueColor()
        }
        //前一个月label
        if dateNum<1 {
            cell.numLabel?.textColor = UIColor.clearColor()
            var days = 0
            if searchmonth != 1 {
                days = MJ_Calendar.getDaysOfMonth(searchYear, month: searchmonth-1)
            }else if(searchmonth == 1){
                days = MJ_Calendar.getDaysOfMonth(searchYear-1, month: 12)
            }
            cell.numLabel?.text = String(dateNum+days)
        }
        
        //后一个月label
        if dateNum>searchDaysOfMonth{
            cell.numLabel?.text = String(dateNum-searchDaysOfMonth)
            cell.numLabel?.textColor = UIColor.clearColor()
        }
        
        /*
         背景颜色设置
         */
        //当前月
        let tempYue = String(format: "%.2d", month)
        let tempSearchYue = String(format: "%.2d", searchmonth)
        if Int("\(year)\(tempYue)") == Int("\(searchYear)\(tempSearchYue)"){
//            nextButton?.hidden = true
            cell.numLabel?.backgroundColor = UIColor.whiteColor()
            cell.numLabel?.layer.masksToBounds = true
            cell.numLabel?.layer.borderColor = UIColor.grayColor().CGColor
            cell.numLabel?.layer.borderWidth = 0
            //月内
            if dateNum>=1 && dateNum<=searchDay {
                cell.numLabel?.backgroundColor=UIColor.whiteColor()
                cell.numLabel?.text=String(dateNum)
                cell.numLabel?.layer.borderWidth=0;
            }
        }
        //之后的月
        if Int("\(year)\(tempYue)") < Int("\(searchYear)\(tempSearchYue)"){
            cell.numLabel?.backgroundColor = UIColor.whiteColor()
            cell.numLabel?.layer.masksToBounds = true
            cell.numLabel?.layer.borderColor = UIColor.grayColor().CGColor
            cell.numLabel?.layer.borderWidth = 0
            
        }
        //之前的月
        if Int("\(year)\(tempYue)") > Int("\(searchYear)\(tempSearchYue)"){
//            nextButton?.hidden = false
            cell.numLabel?.backgroundColor = UIColor.whiteColor()
            cell.numLabel?.layer.masksToBounds = true
            cell.numLabel?.layer.borderColor = UIColor.grayColor().CGColor
            cell.numLabel?.layer.borderWidth = 0
            //月内
            if dateNum>=1 && indexPath.row<searchDaysOfMonth+MJ_Calendar.getWeekOfFirstDayOfMonthWithYear(searchYear, month: searchmonth) {
                cell.numLabel?.backgroundColor = UIColor.whiteColor()
                cell.numLabel?.text = String(dateNum)
                cell.numLabel?.layer.borderWidth=0;
            }
        }
        /*
         设置当前时间 那天 为红色
         
         */
        if Int(currentDateStr!) == Int(String(format: "%.4d%.2d%.2d", searchYear,searchmonth,dateNum)) {
            cell.numLabel?.textColor = UIColor.redColor()
        }
        
        /*
         设置签到颜色
         */
        //-数组内包含当前日期则说明此日期签到了，设置颜色为蓝色；
        if let iscontain = registerArr?.contains(String(format: "%.4d%.2d%.2d", searchYear,searchmonth,dateNum)){
            if iscontain {
                cell.selectImageView?.hidden = false
            }
        }
        cell.numLabel?.frame = CGRectMake((cellWidth-30)*0.5, (cellWidth-38)*0.5, 28, 28)
        cell.selectImageView?.frame = CGRectMake((cellWidth-30)*0.5+19, (cellWidth-38)*0.5+17, 8, 8)
        return cell
    }
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}






















