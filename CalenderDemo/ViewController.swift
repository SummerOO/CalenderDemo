//
//  ViewController.swift
//  CalenderDemo
//
//  Created by Zhang茹儿 on 16/8/31.
//  Copyright © 2016年 Ru.zhang. All rights reserved.
//

import UIKit

let KScreenHeight = UIScreen.mainScreen().bounds.size.height
let KScreenWidth = UIScreen.mainScreen().bounds.size.width


class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    var dateArray = NSArray()
    
    // 时间Label
    lazy var timeLabel: UILabel = {
       let time = UILabel(frame: CGRectZero)
        time.text = "xxxx-xx"
        time.textAlignment = .Center
        self.view.addSubview(time)
        return time
    }()
    
    var myCollection: UICollectionView!
    
    lazy var lastButton: UIButton = {
       let last = UIButton(type: .System)
        last.setTitle("<--", forState: .Normal)
        last.addTarget(self, action: #selector(lastAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(last)
        return last
    }()
    
    lazy var nextButton: UIButton = {
       let next = UIButton(type: .System)
        next.setTitle("-->", forState: .Normal)
        next.addTarget(self, action: #selector(nextAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(next)
        return next
    }()
    
    var date = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIBuild()
        self.myCollection.registerClass(DateCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        self.myCollection.registerClass(WeekCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    
    func UIBuild() {
        dateArray = ["日","一","二","三","四","五","六"]
        lastButton.frame = CGRectMake(10, 50, 30, 40)
        nextButton.frame = CGRectMake(KScreenWidth - 40, 50, 30, 40)
        timeLabel.frame = CGRectMake(lastButton.frame.maxX, lastButton.frame.minY, KScreenWidth - lastButton.frame.width - nextButton.frame.width - 10, 40)
        let item = KScreenWidth / 7 - 5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSizeMake(item, item)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let rect = CGRectMake(10, lastButton.frame.maxY, KScreenWidth, 400)
        myCollection = UICollectionView(frame: rect, collectionViewLayout: layout)
        myCollection.backgroundColor = UIColor.whiteColor()
        myCollection.dataSource = self
        myCollection.delegate = self
        self.view.addSubview(myCollection)
        
        self.timeLabel.text = String(format: "%li-%.2ld", self.year(self.date), self.month(self.date))
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dateArray.count
        default:
            
            let days = self.daysInThisMonth(date)
            let firstWeek = self.firstWeekInThisMonth(date)
            let day = days + firstWeek
            return day
            
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! WeekCollectionViewCell
            cell.timeLabel.text = dateArray[indexPath.row] as? String
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! DateCollectionViewCell
            let days = self.daysInThisMonth(date)
            let week = self.firstWeekInThisMonth(date)
            var day = 0
            let index = indexPath.row
            if index < week {
//                cell.backgroundColor = UIColor.whiteColor()
                cell.timeLabel.text = " "
            } else if index > week + days - 1 {
                cell.backgroundColor = UIColor.redColor()
            } else {
                day = index - week + 1
                cell.timeLabel.text = String(day)
            }
            return cell
        }
    }
    
    
}

extension ViewController {
    
    // 获取当前日期
    func day(date: NSDate) -> NSInteger {
        let com = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        return com.day
    }
    
    // 获取当前月
    func month(date: NSDate) -> NSInteger {
        let com = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        return com.month
    }
    
    // 获取当前年
    func year(date: NSDate) -> NSInteger {
        let com = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        return com.year
    }
    
    // 每个月1号对应的星期
    func firstWeekInThisMonth(date: NSDate) -> NSInteger {
        let calender = NSCalendar.currentCalendar()
        calender.firstWeekday = 1
        let com = calender.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: date)
        com.day = 1
        let firstDay = calender.dateFromComponents(com)
        let firstWeek = calender.ordinalityOfUnit(NSCalendarUnit.Weekday, inUnit: NSCalendarUnit.WeekOfMonth, forDate: firstDay!)
        return firstWeek - 1
    }
    
    // 当前月份的天数
    func daysInThisMonth(date: NSDate) -> NSInteger {
        let days: NSRange = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date)
        return days.length
    }
    
    // 上个月
    func lastMonth(date: NSDate) -> NSDate {
        let dateCom = NSDateComponents()
        dateCom.month = -1
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateCom, toDate: date, options: NSCalendarOptions.MatchStrictly)
        return newDate!
    }
    
    // 下个月
    func nextMonth(date: NSDate) -> NSDate {
        let dateCom = NSDateComponents()
        dateCom.month = +1
        let newDate = NSCalendar.currentCalendar().dateByAddingComponents(dateCom, toDate: date, options: NSCalendarOptions.MatchStrictly)
        return newDate!
    }
    
}

extension ViewController {
    func lastAction() {
        UIView.transitionWithView(self.myCollection, duration: 0.5, options: .TransitionCurlDown, animations: {
            self.date = self.lastMonth(self.date)
            self.timeLabel.text = String(format: "%li-%.2ld", self.year(self.date), self.month(self.date))
            }, completion: nil)
        self.myCollection.reloadData()
    }
    
    func nextAction() {
        UIView.transitionWithView(self.myCollection, duration: 0.5, options: .TransitionCurlUp, animations: {
            self.date = self.nextMonth(self.date)
            self.timeLabel.text = String(format: "%li-%.2ld", self.year(self.date), self.month(self.date))
            }, completion: nil)

        self.myCollection.reloadData()
    }
}