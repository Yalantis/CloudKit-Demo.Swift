//
//  YALCityTableViewCell.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

private let kCellReuseId = "cityTableViewCellReuseId"
private let kCityTableViewCell = "YALCityTableViewCell"

class YALCityTableViewCell: UITableViewCell {

    @IBOutlet var pictureImageView: UIImageView?
    @IBOutlet var nameLable: UILabel?
    
    class func reuseIdentifier() -> String {
        return kCellReuseId
    }
    
    class func nibName() -> String {
        return kCityTableViewCell
    }
    
    func setCity(city: YALCity) {
        self.nameLable?.text = city.name
        self.pictureImageView?.alpha = 0.0
        self.pictureImageView?.image = city.image
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.pictureImageView?.alpha = 1.0
            return
        })
    }
}
