//
//  YALCloudKitManager.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import CloudKit

private let kRecordType: String = "Cities"

class YALCloudKitManager: NSObject {
   
    class func publicCloudDatabase()->CKDatabase {
        return CKContainer.defaultContainer().publicCloudDatabase
    }
    
    // Retrieve existing records
    class func fetchAllCitiesWithCompletionHandler(completion:(records: NSArray, error: NSError!) -> Void) {
        var predicate = NSPredicate(value: true)
        
        var query = CKQuery(recordType: kRecordType, predicate: predicate)
        
        publicCloudDatabase().performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            
            let fetchedRecords = records as NSArray
            
            var temp: NSMutableArray = []
            fetchedRecords.enumerateObjectsUsingBlock({ (obj, index, stop) -> Void in
                let city = YALCity.init(inputData:obj as AnyObject!)
                temp.addObject(city)
            })
            
            dispatch_async(dispatch_get_main_queue(),{
                completion(records: temp, error: nil)
            })
        }
    }
    
    // add a new record
    class func createRecordWithCompletionHandler(recordDic: NSDictionary, completion:(record: AnyObject!, error: NSError!) -> Void) {
        var record: CKRecord? = CKRecord.init(recordType: kRecordType)
        
        for (index, element) in enumerate(recordDic.allKeys) {
            let key: String = element as String
            
            if key == YALCityPicture {
                
                let path: NSString = NSBundle.mainBundle().pathForResource(recordDic[key] as? String, ofType: "png")!
                let data: NSData = NSData.dataWithContentsOfMappedFile(path)! as NSData
                let image: UIImage = UIImage.init(data: data)!
                
                record?.setValue(data, forKey:key)
            } else {
                record?.setValue(recordDic[key], forKey: key)
            }
        }
        
        self.publicCloudDatabase().saveRecord(record, completionHandler: { (savedRecord: CKRecord!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                completion(record: savedRecord, error: error)
            })
        })
    }
    
    // updating the record by recordId
    class func updateRecord(recordId: String, text: String, completion:(record: AnyObject!, error: NSError!) -> Void) {
        let recordId = CKRecordID.init(recordName: recordId)
        self.publicCloudDatabase().fetchRecordWithID(recordId, completionHandler: { (updatedRecord: CKRecord!, error: NSError!) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(),{
                    completion(record: nil, error: error)
                })
                return
            }
            
            updatedRecord.setObject(text, forKey: YALCityText)
            self.publicCloudDatabase().saveRecord(updatedRecord, completionHandler: { (savedRecord: CKRecord!, error: NSError!) -> Void in
                dispatch_async(dispatch_get_main_queue(),{
                    completion(record: savedRecord, error: error)
                })
            })
            
        })
    }
    
    // remove the record
    class func removeRecord(recordId: String, completion:(recordId: String!, error: NSError!) -> Void) {
        let recordId = CKRecordID.init(recordName: recordId)
        self.publicCloudDatabase().deleteRecordWithID(recordId, completionHandler: { (deletedRecordId: CKRecordID!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                completion (recordId: deletedRecordId.recordName, error: error)
            })
        })
    }
    
}
