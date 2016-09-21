//
//  YALCityTableViewCell.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet fileprivate var pictureImageView: UIImageView!
    @IBOutlet fileprivate var nameLable: UILabel!
    
    class var reuseIdentifier: String {
        return "cityTableViewCellReuseId"
    }
    
    class var nibName: String {
        return "CityTableViewCell"
    }
    
    func setCity(_ city: City) {
        nameLable.text = city.name
        pictureImageView.alpha = 0.0
        pictureImageView.image = city.image
        
        UIView.animate(withDuration: 0.3) {
            self.pictureImageView.alpha = 1.0
        }
    }
}
