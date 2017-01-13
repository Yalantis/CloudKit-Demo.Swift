<p align="center" >
  <img src="https://github.com/Yalantis/CloudKit-Demo.Swift/blob/master/CloudKit-Swift.png" alt="CloudKit" title="CloudKit">
</p>

CloudKit, Apple’s remote data storage service, provides a possibility to store app data using users’ iCloud accounts as a back-end storage service.

Here is the same demo on [Objective-C](https://github.com/Yalantis/CloudKit-Demo.Objective-C).

## Requirements

- iOS 8.0+
- XCode 8
- Swift 3

## How To Get Started

- Set up Cloud/CloudKit at iOS Developer Portal.
- Insert a bundle identifier and choose a corresponding Team.
- Select Capabilities tab in the target editor, and then switch ON the iCloud.

For more detailed information take a look at [our article](https://yalantis.com/blog/work-cloudkit/?utm_source=github).

## Usage

### Retrieve existing records

```swift
let predicate = NSPredicate(value: true)
let query = CKQuery(recordType: recordType, predicate: predicate)
CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in

}
```

### Create a new record

```swift
let record = CKRecord(recordType: "RecordType")
record.setValue("Some data", forKey: "key")
CKContainer.default().publicCloudDatabase.save(record) { savedRecord, error in

}
```

### Update the record

```swift
let recordId = CKRecordID(recordName: "RecordType")
CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordId) { updatedRecord, error in  
    if error != nil {
        return
    }

    updatedRecord.setObject("Some data", forKey: "key")
    CKContainer.default().publicCloudDatabase.save(updatedRecord) { savedRecord, error in

    }
}
```

### Remove the record

```swift
let recordId = CKRecordID(recordName: recordId)
CKContainer.default().publicCloudDatabase.delete(withRecordID: recordId) { deletedRecordId, error in

}
```

## Contacts

[Yalantis](http://yalantis.com)

Follow Yalantis on Twitter ([@Yalantis](https://twitter.com/yalantis)) and [Facebook] (https://www.facebook.com/Yalantis?ref=ts&fref=ts)

## License

    The MIT License (MIT)

    Copyright © 2017 Yalantis

    Permission is hereby granted free of charge to any person obtaining a copy of this software and associated documentation files (the "Software") to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
    
