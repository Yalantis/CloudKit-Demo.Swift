//
//  YALSelectCityViewController.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/30/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

private let kCellReuseId = "selectCityReuseId"
private let kUnwindSelectCitySegue = "unwindSelectCityToMainId"

class YALSelectCityViewController: YALBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    internal var selectedCity = YALCity()
    
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var indicatorView: UIActivityIndicatorView?
    
    // MARK: IBActions
    @IBAction private func saveButtonDidPress(button:UIButton) {
        let selectedRows: NSArray? = self.tableView?.indexPathsForSelectedRows()
        let selectedIndexPath: NSIndexPath = selectedRows?.lastObject as NSIndexPath
        let recordDic: NSDictionary = YALCity.defaultContent().allValues[selectedIndexPath.row] as NSDictionary
        self.shouldAnimateIndicator(true)
        YALCloudKitManager.createRecordWithCompletionHandler(recordDic, completion: { [weak self] (record, error) -> Void in
            
            self?.shouldAnimateIndicator(false)
            if error != nil {
                self?.presentMessage(error.localizedDescription)
                return
            }
            
            self?.selectedCity = YALCity(inputData: record)
            self?.performSegueWithIdentifier(kUnwindSelectCitySegue, sender: self)
        })
    }
    
    // MARK: Private
    private func shouldAnimateIndicator(animate: Bool) {
        if animate {
            self.indicatorView?.startAnimating()
        } else {
            self.indicatorView?.stopAnimating()
        }
        
        self.tableView?.userInteractionEnabled = !animate
        self.navigationController?.navigationBar.userInteractionEnabled = !animate
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YALCity.defaultContent().allKeys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellReuseId) as UITableViewCell
        
        let cityName = YALCity.defaultContent().allKeys[indexPath.row] as String
        cell.textLabel?.text = cityName
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.None {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.None
    }
}
