//
//  YALCloudKitManager.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import CloudKit

private let kRecordType = "Cities"

final class YALCloudKitManager {
    
    private init() {
        ///forbide to create instance of helper class
    }
    
    static func publicCloudDatabase() -> CKDatabase {
        return CKContainer.defaultContainer().publicCloudDatabase
    }
    
    //MARK: Retrieve existing records
    static func fetchAllCitiesWithCompletionHandler(completion: (records: [YALCity]!, error: NSError?) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: kRecordType, predicate: predicate)
        
        publicCloudDatabase().performQuery(query, inZoneWithID: nil) { (records, error) -> Void in
            let cities = records?.map { YALCity(record: $0) }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(records: cities, error: error)
            }
        }
    }
    
    //MARK: add a new record
    static func createRecordWithCompletionHandler(recordDic: [String: String], completion: (CKRecord!, NSError?) -> Void) {
        let record = CKRecord(recordType: kRecordType)
        
        for (key, value) in recordDic {
            if key == YALCityPicture {
                var data: NSData?
                if let path = NSBundle.mainBundle().pathForResource(value, ofType: "jpg") {
                    do {
                        data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: .DataReadingMappedIfSafe)
                    } catch let error {
                        print(error)
                    }
                }
                
                record.setValue(data, forKey: key)
            } else {
                record.setValue(value, forKey: key)
            }
        }
        
        publicCloudDatabase().saveRecord(record, completionHandler: { (savedRecord, error) in
            dispatch_async(dispatch_get_main_queue()) {
                completion(record, error)
            }
        })
    }
    
    //MARK: updating the record by recordId
    static func updateRecord(recordId: String, text: String, completion: (CKRecord!, NSError?) -> Void) {
        let recordId = CKRecordID(recordName: recordId)
        publicCloudDatabase().fetchRecordWithID(recordId, completionHandler: { (updatedRecord, error) in
            
            guard let record = updatedRecord else  {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(updatedRecord, error)
                }
                return
            }
            
            self.publicCloudDatabase().saveRecord(record, completionHandler: { (savedRecord, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    completion(savedRecord, error)
                }
            })
            
        })
    }
    
    //MARK: remove the record
    static func removeRecord(recordId: String, completion: (String!, NSError?) -> Void) {
        let recordId = CKRecordID(recordName: recordId)
        publicCloudDatabase().deleteRecordWithID(recordId, completionHandler: { (deletedRecordId, error) in
            dispatch_async(dispatch_get_main_queue()) {
                completion (deletedRecordId?.recordName, error)
            }
        })
    }
    
}
