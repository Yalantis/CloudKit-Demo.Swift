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
    fileprivate var selectedIndexPath: IndexPath?
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var indicatorView: UIActivityIndicatorView!
    
    // MARK: IBActions
    @IBAction fileprivate func saveButtonDidPress(_ button:UIButton) {
        if let selectedIndexPath = tableView.indexPathsForSelectedRows?.last {
            let cityData = City.defaultContent()[(selectedIndexPath as NSIndexPath).row]
            shouldAnimateIndicator(true)
            CloudKitManager.createRecord(cityData, completion: { (record, error) -> Void in
                self.shouldAnimateIndicator(false)
                
                if let record = record {
                    self.selectedCity = City(record: record)
                    self.performSegue(withIdentifier: kUnwindSelectCitySegue, sender: self)
                } else if let error = error {
                    self.presentMessage(error.localizedDescription)
                }
            })
        }
    }
    
    // MARK: Private
    fileprivate func shouldAnimateIndicator(_ animate: Bool) {
        if animate {
            self.indicatorView.startAnimating()
        } else {
            self.indicatorView.stopAnimating()
        }
        
        self.tableView.isUserInteractionEnabled = !animate
        self.navigationController!.navigationBar.isUserInteractionEnabled = !animate
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return City.defaultContent().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseId, for: indexPath)
        
        let cityName = City.defaultContent()[(indexPath as NSIndexPath).row]["name"]
        cell.textLabel?.text = cityName
        
        cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .none
        selectedIndexPath = nil
    }
}
