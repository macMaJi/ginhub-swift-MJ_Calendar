//
//  MJ_Calendar.swift
//  swift-Calendar
//
//  Created by mac on 16/10/11.
//  Copyright © 2016年 mac. All rights reserved.
//

import UIKit

class MJ_Calendar: NSObject {

    //返回当前年
    class func getYear() ->(Int) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let nowdate = NSDate()
        var nowDateComps = NSDateComponents()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        nowDateComps = (calendar?.components([.Year , .Month , .Day], fromDate: nowdate))!
        return nowDateComps.year
    }
    //返回当前月
    class func getMonth() ->(Int) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let nowdate = NSDate()
        var nowDateComps = NSDateComponents()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        nowDateComps = (calendar?.components([.Year , .Month , .Day] , fromDate: nowdate))!
        return nowDateComps.month
    }
    //返回当前日
    class func getDay() ->(Int) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let nowdate = NSDate()
        var nowDateComps = NSDateComponents()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        nowDateComps = (calendar?.components([.Year , .Month , .Day] , fromDate: nowdate))!
        return nowDateComps.day
    }
    //获得某个月的第一天是星期几
    class func getWeekOfFirstDayOfMonthWithYear(year:Int , month:Int) -> (Int){
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let firstWeekDayMonth = "\(year)-\(month)-1"
        let weekOfFirstDayOfMonth = dateFormatter.dateFromString(firstWeekDayMonth)
        let newCom = calendar?.components([.Year, .Month, .Day, .Weekday] , fromDate: weekOfFirstDayOfMonth!)
        return (newCom?.weekday)! - 1
    }
    //返回一个月有多少天
    class func getDaysOfMonth(year:Int,month:Int) -> (Int) {
        var days = 0
        let bigMonth = ["1","3","5","7","8","10","12"]
        let milMonth = ["4","6","9","11"]
        if bigMonth.contains(String(month)) {
            days = 31
        }else if milMonth.contains(String(month)) {
            days = 30
        }else{
            if self.isLoopYear(year) {
                days = 29
            }else{
                days = 28
            }
        }
        return days         
    }
    //判断是否是润年
    class func isLoopYear(year:Int) -> (Bool) {
        if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0 {
            return true
        }else {
            return false
        }
    }
}








