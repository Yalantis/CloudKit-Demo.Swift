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
    class func fetchAllCitiesWithCompletionHandler(completion:(records: [YALCity], error: NSError!) -> Void) {
        var predicate = NSPredicate(value: true)
        
        var query = CKQuery(recordType: kRecordType, predicate: predicate)
        
        publicCloudDatabase().performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            
            let cities = (records as [CKRecord]).map({ (record: CKRecord) -> YALCity in
                 return YALCity(record: record)
            })
                
            dispatch_async(dispatch_get_main_queue(),{
                completion(records: cities, error: error)
            })
        }
    }
    
    // add a new record
    class func createRecordWithCompletionHandler(recordDic: Dictionary<String, String>, completion:(record: CKRecord, error: NSError!) -> Void) {
        var record = CKRecord(recordType: kRecordType)
        
        for element in recordDic.keys.array {
            if element == YALCityPicture {
                
                let path = NSBundle.mainBundle().pathForResource(recordDic[element], ofType: "png")!
                let data = NSData.dataWithContentsOfMappedFile(path)! as NSData
                let image: UIImage = UIImage.init(data: data)!
                
                record.setValue(data, forKey:element)
            } else {
                record.setValue(recordDic[element], forKey: element)
            }
        }
        
        self.publicCloudDatabase().saveRecord(record, completionHandler: { (savedRecord: CKRecord!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                completion(record: savedRecord, error: error)
            })
        })
    }
    
    // updating the record by recordId
    class func updateRecord(recordId: String, text: String, completion:(record: CKRecord, error: NSError!) -> Void) {
        let recordId = CKRecordID(recordName: recordId)
        self.publicCloudDatabase().fetchRecordWithID(recordId, completionHandler: { (updatedRecord: CKRecord!, error: NSError!) -> Void in
            
            if error != nil {
                dispatch_async(dispatch_get_main_queue(),{
                    completion(record: updatedRecord, error: error)
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
        let recordId = CKRecordID(recordName: recordId)
        self.publicCloudDatabase().deleteRecordWithID(recordId, completionHandler: { (deletedRecordId: CKRecordID!, error: NSError!) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                completion (recordId: deletedRecordId.recordName, error: error)
            })
        })
    }
    
}
