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

class SelectCityViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedCity: City!
    private var selectedIndexPath: NSIndexPath?
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var indicatorView: UIActivityIndicatorView!
    
    // MARK: IBActions
    @IBAction private func saveButtonDidPress(button:UIButton) {
        if let selectedIndexPath = tableView.indexPathsForSelectedRows?.last {
            let cityData = City.defaultContent()[selectedIndexPath.row]
            shouldAnimateIndicator(true)
            CloudKitManager.createRecord(cityData, completion: { (record, error) -> Void in
                self.shouldAnimateIndicator(false)
                
                if let record = record {
                    self.selectedCity = City(record: record)
                    self.performSegueWithIdentifier(kUnwindSelectCitySegue, sender: self)
                } else {
                    self.presentMessage(error.localizedDescription)
                }
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
        return City.defaultContent().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellReuseId, forIndexPath: indexPath)
        
        let cityName = City.defaultContent()[indexPath.row]["name"]
        cell.textLabel?.text = cityName
        
        cell.accessoryType = indexPath == selectedIndexPath ? .Checkmark : .None
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = .Checkmark
        selectedIndexPath = indexPath
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        cell?.accessoryType = .None
        selectedIndexPath = indexPath
    }
}
