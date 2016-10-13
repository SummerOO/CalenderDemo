//
//  ViewController.swift
//  CalenderDemo
//
//  Created by Zhang茹儿 on 16/8/31.
//  Copyright © 2016年 Ru.zhang. All rights reserved.
//

import UIKit

let KScreenHeight = UIScreen.main.bounds.size.height
let KScreenWidth = UIScreen.main.bounds.size.width


class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    var dateArray = NSArray()
    
    // 时间Label
    lazy var timeLabel: UILabel = {
       let time = UILabel(frame: CGRect.zero)
        time.text = "xxxx-xx"
        time.textAlignment = .center
        self.view.addSubview(time)
        return time
    }()
    
    var myCollection: UICollectionView!
    
    lazy var lastButton: UIButton = {
       let last = UIButton(type: .system)
        last.setTitle("<--", for: UIControlState())
        last.setTitleColor(UIColor.black, for: UIControlState())
        last.addTarget(self, action: #selector(lastAction), for: .touchUpInside)
        self.view.addSubview(last)
        return last
    }()
    
    lazy var nextButton: UIButton = {
       let next = UIButton(type: .system)
        next.setTitle("-->", for: UIControlState())
        next.setTitleColor(UIColor.black, for: UIControlState())
        next.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        self.view.addSubview(next)
        return next
    }()
    
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UIBuild()
        self.myCollection.register(DateCollectionViewCell.self, forCellWithReuseIdentifier: "CELL")
        self.myCollection.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController {
    
    func UIBuild() {
        dateArray = ["日","一","二","三","四","五","六"]
        lastButton.frame = CGRect(x: 10, y: 50, width: 30, height: 40)
        nextButton.frame = CGRect(x: KScreenWidth - 40, y: 50, width: 30, height: 40)
        timeLabel.frame = CGRect(x: lastButton.frame.maxX, y: lastButton.frame.minY, width: KScreenWidth - lastButton.frame.width - nextButton.frame.width - 10, height: 40)
        let item = KScreenWidth / 7 - 5
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: item, height: item)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let rect = CGRect(x: 10, y: lastButton.frame.maxY, width: KScreenWidth, height: 400)
        myCollection = UICollectionView(frame: rect, collectionViewLayout: layout)
        myCollection.backgroundColor = UIColor.white
        myCollection.dataSource = self
        myCollection.delegate = self
        self.view.addSubview(myCollection)
        
        self.timeLabel.text = String(format: "%li-%.2ld", self.year(self.date), self.month(self.date))

        
    }
    
    @objc(numberOfSectionsInCollectionView:) func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeekCollectionViewCell
            cell.timeLabel.text = dateArray[(indexPath as NSIndexPath).row] as? String
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! DateCollectionViewCell
            let days = self.daysInThisMonth(date)
            let week = self.firstWeekInThisMonth(date)
            var day = 0
            let index = (indexPath as NSIndexPath).row
            if index < week {
//                cell.backgroundColor = UIColor.whiteColor()
                cell.timeLabel.text = " "
            } else if index > week + days - 1 {
                cell.backgroundColor = UIColor.red
            } else {
                day = index - week + 1
                cell.timeLabel.text = String(day)
                
                let da = Date()
                let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: da)
                
                let abc = String(format: "%li-%.2ld", com.year!, com.month!)
                
                if self.timeLabel.text! == abc {
                    
                    if cell.timeLabel.text == String(self.day(date)) {
                        cell.backgroundColor = UIColor.cyan
                    } else {
                        cell.backgroundColor = UIColor.white
                    }

                } else {
                    cell.backgroundColor = UIColor.white
                }
                
                
                
            }
            return cell
        }
    }
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! DateCollectionViewCell
        print(cell.timeLabel.text)
    }
    
}

extension ViewController {
    
    // 获取当前日期
    func day(_ date: Date) -> NSInteger {
        let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        return com.day!
    }
    
    // 获取当前月
    func month(_ date: Date) -> NSInteger {
        let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        return com.month!
    }
    
    // 获取当前年
    func year(_ date: Date) -> NSInteger {
        let com = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        return com.year!
    }
    
    // 每个月1号对应的星期
    func firstWeekInThisMonth(_ date: Date) -> NSInteger {
        var calender = Calendar.current
        calender.firstWeekday = 1
        var com = (calender as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: date)
        com.day = 1
        let firstDay = calender.date(from: com)
        let firstWeek = (calender as NSCalendar).ordinality(of: NSCalendar.Unit.weekday, in: NSCalendar.Unit.weekOfMonth, for: firstDay!)
        return firstWeek - 1
    }
    
    // 当前月份的天数
    func daysInThisMonth(_ date: Date) -> NSInteger {
        let days: NSRange = (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date)
        return days.length
    }
    
    // 上个月
    func lastMonth(_ date: Date) -> Date {
        var dateCom = DateComponents()
        dateCom.month = -1
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }
    
    // 下个月
    func nextMonth(_ date: Date) -> Date {
        var dateCom = DateComponents()
        let abc = 1
        dateCom.month = +abc
        let newDate = (Calendar.current as NSCalendar).date(byAdding: dateCom, to: date, options: NSCalendar.Options.matchStrictly)
        return newDate!
    }
    
}

extension ViewController {
    func lastAction() {
        UIView.transition(with: self.myCollection, duration: 0.5, options: .transitionCurlDown, animations: {
            self.date = self.lastMonth(self.date)
            self.timeLabel.text = String(format: "%li-%.2ld", self.year(self.date), self.month(self.date))
            }, completion: nil)
        self.myCollection.reloadData()
    }
    
    func nextAction() {
        UIView.transition(with: self.myCollection, duration: 0.5, options: .transitionCurlUp, animations: {
            self.date = self.nextMonth(self.date)
            self.timeLabel.text = String(format: "%li-%.2ld", self.year(self.date), self.month(self.date))
            }, completion: nil)

        self.myCollection.reloadData()
    }
}
