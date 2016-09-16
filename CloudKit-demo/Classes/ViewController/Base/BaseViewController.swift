//
//  YALBaseViewController.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: Public
    func presentMessage(_ message: String) {
        
        let alert = UIAlertView()
        alert.title = "CloudKit"
        alert.message = message
        alert.addButton(withTitle: "Ok")
        alert.show()
    }
}
