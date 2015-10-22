//
//  YALSelectCityViewController.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/30/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit
import CloudKit

private let kCellReuseId = "selectCityReuseId"
private let kUnwindSelectCitySegue = "unwindSelectCityToMainId"

class YALSelectCityViewController: YALBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedCity: YALCity!
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var indicatorView: UIActivityIndicatorView!
    
    // MARK: IBActions
    @IBAction private func saveButtonDidPress(button:UIButton) {
        if let selectedIndexPath = tableView.indexPathsForSelectedRows?.last {
            let recordDic = YALCity.defaultContent()[selectedIndexPath.row]
            shouldAnimateIndicator(true)
            YALCloudKitManager.createRecordWithCompletionHandler(recordDic, completion: { (record, error) -> Void in
                self.shouldAnimateIndicator(false)
                if let error = error {
                    self.presentMessage(error.localizedDescription)
                    return
                }
                
                self.selectedCity = YALCity(record: record)
                self.performSegueWithIdentifier(kUnwindSelectCitySegue, sender: self)
            })
        }
    }
    
    // MARK: Private
    private func shouldAnimateIndicator(animate: Bool) {
        if animate {
            self.indicatorView.startAnimating()
        } else {
            self.indicatorView.stopAnimating()
        }
        
        self.tableView.userInteractionEnabled = !animate
        self.navigationController!.navigationBar.userInteractionEnabled = !animate
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YALCity.defaultContent().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellReuseId, forIndexPath: indexPath)
        
        let cityName = YALCity.defaultContent()[indexPath.row]["name"]
        cell.textLabel?.text = cityName
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.accessoryType == .None {
            cell?.accessoryType = .Checkmark
        } else {
            cell?.accessoryType = .None
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
    }
}
