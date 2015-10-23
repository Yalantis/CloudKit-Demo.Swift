//
//  YALCityTableViewCell.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

private let kCellReuseId = "cityTableViewCellReuseId"
private let kCityTableViewCell = "CityTableViewCell"

class CityTableViewCell: UITableViewCell {

    @IBOutlet var pictureImageView: UIImageView!
    @IBOutlet var nameLable: UILabel!
    
    class func reuseIdentifier() -> String {
        return kCellReuseId
    }
    
    class func nibName() -> String {
        return kCityTableViewCell
    }
    
    func setCity(city: City) {
        nameLable.text = city.name
        pictureImageView.alpha = 0.0
        pictureImageView.image = city.image
        
        UIView.animateWithDuration(0.3, animations: {
            self.pictureImageView.alpha = 1.0
        })
    }
}
