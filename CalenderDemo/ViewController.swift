//
//  ViewController.swift
//  CalenderDemo
//
//  Created by Zhang茹儿 on 16/8/31.
//  Copyright © 2016年 Ru.zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    
    lazy var timeLabel: UILabel = {
       let time = UILabel(frame: CGRectZero)
        time.text = "xxxx-xx"
        time.backgroundColor = UIColor.blackColor()
        time.textColor = UIColor.whiteColor()
        return time
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

