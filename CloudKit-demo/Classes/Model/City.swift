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
    
    init(record: CKRecord) {
        self.name = record.value(forKey: cityName) as! String
        self.text = record.value(forKey: cityText) as! String
        if let imageData = record.value(forKey: cityPicture) as? Data {
            self.image = UIImage(data:imageData)
        }
        self.identifier = record.recordID.recordName
    }
    
    static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension City {
    
    static var defaultContent: [[String: String]] {
        if cities == nil {
            let path = Bundle.main.path(forResource: kCitiesSourcePlist, ofType: "plist")
            let plistData = try? Data(contentsOf: URL(fileURLWithPath: path!))
            assert(plistData != nil, "Source doesn't exist")
            
            do {
                cities = try PropertyListSerialization.propertyList(from: plistData!,
                                                                    options: .mutableContainersAndLeaves, format: nil) as? [[String: String]]
            }
            catch _ {
                print("Cannot read data from the plist")
            }
        }
        
        return cities
    }
}
