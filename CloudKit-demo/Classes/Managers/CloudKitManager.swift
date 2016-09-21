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
    
    fileprivate init() {
        ///forbide to create instance of helper class
    }
    
    static var publicCloudDatabase: CKDatabase {
        return CKContainer.default().publicCloudDatabase
    }
    
    //MARK: Retrieve existing records
    static func fetchAllCities(_ completion: @escaping (_ records: [City]?, _ error: NSError?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            let cities = records?.map(City.init)
            DispatchQueue.main.async {
                completion(cities, error as NSError?)
            }
        }
    }
    
    //MARK: add a new record
    static func createRecord(_ recordData: [String: String], completion: @escaping (_ record: CKRecord?, _ error: NSError?) -> Void) {
        let record = CKRecord(recordType: recordType)
        
        for (key, value) in recordData {
            if key == cityPicture {
                if let path = Bundle.main.path(forResource: value, ofType: "jpg") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        record.setValue(data, forKey: key)
                    } catch let error {
                        print(error)
                    }
                }
            } else {
                record.setValue(value, forKey: key)
            }
        }
        
        publicCloudDatabase.save(record) { (savedRecord, error) in
            DispatchQueue.main.async {
                completion(record, error as? NSError)
            }
        }
    }
    
    //MARK: updating the record by recordId
    static func updateRecord(_ recordId: String, text: String, completion: @escaping (CKRecord?, NSError?) -> Void) {
        let recordId = CKRecordID(recordName: recordId)
        publicCloudDatabase.fetch(withRecordID: recordId) { updatedRecord, error in
            guard let record = updatedRecord else {
                DispatchQueue.main.async {
                    completion(nil, error as NSError?)
                }
                return
            }
            
            record.setValue(text, forKey: cityText)
            self.publicCloudDatabase.save(record) { savedRecord, error in
                DispatchQueue.main.async {
                    completion(savedRecord, error as? NSError)
                }
            }
        }
    }
    
    //MARK: remove the record
    static func removeRecord(_ recordId: String, completion: @escaping (String?, NSError?) -> Void) {
        let recordId = CKRecordID(recordName: recordId)
        publicCloudDatabase.delete(withRecordID: recordId, completionHandler: { deletedRecordId, error in
            DispatchQueue.main.async {
                completion (deletedRecordId?.recordName, error as NSError?)
            }
        })
    }
    
    //MARK: check that user is logged
    static func checkLoginStatus(_ handler: @escaping (_ islogged: Bool) -> Void) {
        CKContainer.default().accountStatus{ accountStatus, error in
            if let error = error {
                print(error.localizedDescription)
            }
            switch accountStatus {
            case .available:
                handler(true)
            default:
                handler(false)
            }
        }
    }
}
