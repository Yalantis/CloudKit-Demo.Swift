//
//  YALCloudKitManager.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import CloudKit

private let recordType = "Cities"

final class CloudKitManager {
    
    private init() {
        ///forbide to create instance of helper class
    }
    
    static func publicCloudDatabase() -> CKDatabase {
        return CKContainer.defaultContainer().publicCloudDatabase
    }
    
    //MARK: Retrieve existing records
    static func fetchAllCities(completion: (records: [City]?, error: NSError!) -> Void) {
        publicCloudDatabase().fetchAllRecordZonesWithCompletionHandler { (zones, error) -> Void in
            print(zones)
        }
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        publicCloudDatabase().performQuery(query, inZoneWithID: nil) { (records, error) in
            let cities = records?.map { City(record: $0) }
            
            dispatch_async(dispatch_get_main_queue()) {
                completion(records: cities, error: error)
            }
        }
    }
    
    //MARK: add a new record
    static func createRecord(recordData: [String: String], completion: (record: CKRecord?, error: NSError!) -> Void) {
        let record = CKRecord(recordType: recordType)
        
        for (key, value) in recordData {
            if key == cityPicture {
                if let path = NSBundle.mainBundle().pathForResource(value, ofType: "jpg") {
                    do {
                        let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: .DataReadingMappedIfSafe)
                        record.setValue(data, forKey: key)
                    } catch let error {
                        print(error)
                    }
                }
            } else {
                record.setValue(value, forKey: key)
            }
        }
        
        publicCloudDatabase().saveRecord(record, completionHandler: { (savedRecord, error) in
            dispatch_async(dispatch_get_main_queue()) {
                completion(record: record, error: error)
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
    
    //MARK: check that user is logged
    static func checkLoginStatus(handler: () -> Void) {
        CKContainer.defaultContainer().accountStatusWithCompletionHandler{ (accountStatus, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            switch  accountStatus{
            case .Available:
                handler()
            default:
                print("account unavailable")
            }
        }
    }
    
}
