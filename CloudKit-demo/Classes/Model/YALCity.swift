//
//  YALCity.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import CloudKit

let YALCityName = "name"
let YALCityText = "text"
let YALCityPicture = "picture"

private let kCitiesSourcePlist = "Cities"

class YALCity: Equatable {
    
    var name: String
    var text: String
    var image: UIImage
    var identifier: String
    
    // MARK: Class methods
    class internal func defaultContent() -> Dictionary<String, Dictionary<String, String>> {
        
        let path = NSBundle.mainBundle().pathForResource(kCitiesSourcePlist, ofType: "plist")
        let plistData = NSData(contentsOfFile: path!)
        assert(plistData != nil, "Source doesn't exist")
        
        var format: NSPropertyListFormat?
        var error: NSError?
        var plistDic = NSPropertyListSerialization.propertyListWithData(plistData!,
                            options:Int(NSPropertyListMutabilityOptions.MutableContainersAndLeaves.rawValue),
                             format: nil, error: &error) as Dictionary<String, Dictionary<String, String>>
        
        assert(error == nil, "Can not read data from the plist")

        return plistDic
    }
    
    init(record:CKRecord) {
        self.name = record.valueForKey(YALCityName) as String
        self.text = record.valueForKey(YALCityText) as String
        var imageData = record.valueForKey(YALCityPicture) as NSData
        self.image = UIImage(data:imageData)!
        self.identifier = record.recordID.recordName
    }
    
}

func ==(lhs: YALCity, rhs: YALCity) -> Bool {
    return lhs.identifier == rhs.identifier
}
