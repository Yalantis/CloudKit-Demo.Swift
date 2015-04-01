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

class YALDetailedViewController: YALBaseViewController {

    internal var city = YALCity()
    
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var cityImageView: UIImageView?
    @IBOutlet private var nameLabel: UILabel?
    @IBOutlet private var descriptionTextView: UITextView?
    @IBOutlet private var indicatorView: UIActivityIndicatorView?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // MARK: Private
    private func setupView() {
        self.cityImageView?.image = self.city.image
        self.nameLabel?.text = self.city.name
        self.descriptionTextView?.text = self.city.text
    }
    
    private func shouldAnimateIndicator(animate: Bool) {
        if animate {
            self.indicatorView?.startAnimating()
        } else {
            self.indicatorView?.stopAnimating()
        }
        
        self.view.userInteractionEnabled = !animate
        self.navigationController?.navigationBar.userInteractionEnabled = !animate
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue()
        
        let keyboardHeight = keyboardSize?.height as CGFloat!
        let contentOffsetX = self.scrollView?.contentOffset.x as CGFloat!
        let contentOffsetY = self.scrollView?.contentOffset.y as CGFloat!
        
        self.scrollView?.contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY + keyboardHeight)
    }
    
    // MARK: IBActions
    @IBAction private func saveButtonDidPress(button:UIButton) {
        self.view.endEditing(true)
        
        let identifier = self.city.identifier as String
        let updatedText = self.descriptionTextView?.text as String!
        shouldAnimateIndicator(true)
        
        YALCloudKitManager.updateRecord(identifier, text: updatedText) { [weak self] (record, error) -> Void in
            
            self?.shouldAnimateIndicator(false)
            if error != nil {
                self?.presentMessage(error.localizedDescription)
                return
            }
            
            self?.city.text = record.valueForKey("text") as NSString?
            self?.presentMessage(kUpdatedMessage)
        }
    }
    
    @IBAction private func removeButtonDidPress(button:UIButton) {
        self.shouldAnimateIndicator(true)
        YALCloudKitManager.removeRecord(self.city.identifier!, completion: { [weak self] (recordId, error) -> Void in
            
            self?.shouldAnimateIndicator(false)
            
            if error != nil {
                self?.presentMessage(error.localizedDescription)
                return
            }
            
            self?.performSegueWithIdentifier(kUnwindSegue, sender: self)
        })
    }
}
