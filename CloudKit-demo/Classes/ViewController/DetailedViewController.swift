//
//  YALDetailedViewController.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/31/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

private let kUpdatedMessage = "City has been updated successfully"
private let kUnwindSegue = "unwindToMainId"

class DetailedViewController: BaseViewController {
    
    var city: City!
    
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet fileprivate var cityImageView: UIImageView!
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var descriptionTextView: UITextView!
    @IBOutlet fileprivate var indicatorView: UIActivityIndicatorView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        NotificationCenter.default.addObserver(self, selector:#selector(DetailedViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    // MARK: Private
    fileprivate func setupView() {
        cityImageView.image = city.image
        nameLabel.text = city.name
        descriptionTextView.text = city.text
    }
    
    fileprivate func shouldAnimateIndicator(_ animate: Bool) {
        if animate {
            self.indicatorView.startAnimating()
        } else {
            self.indicatorView.stopAnimating()
        }
        
        self.view.isUserInteractionEnabled = !animate
        self.navigationController!.navigationBar.isUserInteractionEnabled = !animate
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
        
        let keyboardHeight = keyboardSize.height
        let contentOffsetX = self.scrollView.contentOffset.x
        let contentOffsetY = self.scrollView.contentOffset.y
        
        self.scrollView.contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY + keyboardHeight)
    }
    
    // MARK: IBActions
    @IBAction fileprivate func saveButtonDidPress(_ button:UIButton) {
        view.endEditing(true)
        
        let identifier = city.identifier
        let updatedText = descriptionTextView.text!
        
        shouldAnimateIndicator(true)
        CloudKitManager.updateRecord(identifier, text: updatedText) { record, error in
            self.shouldAnimateIndicator(false)
            if let error = error {
                self.presentMessage(error.localizedDescription)
            } else if let record = record {
                self.city.text = record.value(forKey: cityText) as! String
                self.presentMessage(kUpdatedMessage)
            }
        }
    }
    
    @IBAction fileprivate func removeButtonDidPress(_ button:UIButton) {
        self.shouldAnimateIndicator(true)
        CloudKitManager.removeRecord(city.identifier) { recordId, error in
            self.shouldAnimateIndicator(false)
            
            if let error = error {
                self.presentMessage(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: kUnwindSegue, sender: self)
            }
        }
    }
}
