//
//  YALBaseViewController.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

class YALBaseViewController: UIViewController {

    // MARK: Public
    func presentMessage(message : NSString) {
        
        let alert = UIAlertView()
        alert.title = "CloudKit"
        alert.message = message
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
}
