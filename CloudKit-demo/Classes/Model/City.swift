//
//  YALCity.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import CloudKit

let cityName = "name"
let cityText = "text"
let cityPicture = "picture"

private let kCitiesSourcePlist = "Cities"

class City: Equatable {
    
    static var cities: [[String: String]]!
    
    var name: String
    var text: String
    var image: UIImage?
    var identifier: String
    
    // MARK: Class methods
    static func defaultContent() -> [[String: String]] {
        if cities == nil {
            let path = NSBundle.mainBundle().pathForResource(kCitiesSourcePlist, ofType: "plist")
            let plistData = NSData(contentsOfFile: path!)
            assert(plistData != nil, "Source doesn't exist")
            
            do {
                cities = try NSPropertyListSerialization.propertyListWithData(plistData!,
                    options: .MutableContainersAndLeaves, format: UnsafeMutablePointer()) as! [[String: String]]
            }
            catch _ {
                print("Cannot read data from the plist")
            }
        }

        return cities
    }
    
    init(record: CKRecord) {
        self.name = record.valueForKey(cityName) as! String
        self.text = record.valueForKey(cityText) as! String
        if let imageData = record.valueForKey(cityPicture) as? NSData {
            self.image = UIImage(data:imageData)
        }
        self.identifier = record.recordID.recordName
    }
    
}

func ==(lhs: City, rhs: City) -> Bool {
    return lhs.identifier == rhs.identifier
}
