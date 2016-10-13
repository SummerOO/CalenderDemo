//
//  DateCollectionViewCell.swift
//  CalenderDemo
//
//  Created by Zhang茹儿 on 16/9/6.
//  Copyright © 2016年 Ru.zhang. All rights reserved.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    lazy var timeLabel: UILabel = {
        let time = UILabel(frame: CGRect.zero)
        self.addSubview(time)
        return time
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        timeLabel.frame = CGRect(x: 0, y: 10, width: 30, height: 20)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
