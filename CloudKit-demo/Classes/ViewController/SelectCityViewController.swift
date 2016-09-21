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

class SelectCityViewController: BaseViewController {
    
    var selectedCity: City!
    fileprivate var selectedIndexPath: IndexPath?
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var indicatorView: UIActivityIndicatorView!
    
    // MARK: IBActions
    @IBAction fileprivate func saveButtonDidPress(_ button:UIButton) {
        if let selectedIndexPath = tableView.indexPathsForSelectedRows?.last {
            let cityData = City.defaultContent[selectedIndexPath.row]
            shouldAnimateIndicator(true)
            
            CloudKitManager.createRecord(cityData) { record, error in
                self.shouldAnimateIndicator(false)
                
                if let record = record {
                    self.selectedCity = City(record: record)
                    self.performSegue(withIdentifier: kUnwindSelectCitySegue, sender: self)
                } else if let error = error {
                    self.presentMessage(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: Private
    fileprivate func shouldAnimateIndicator(_ animate: Bool) {
        if animate {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
        
        tableView.isUserInteractionEnabled = !animate
        navigationController!.navigationBar.isUserInteractionEnabled = !animate
    }
}

// MARK: UITableViewDataSource
extension SelectCityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return City.defaultContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellReuseId, for: indexPath)
        
        let cityName = City.defaultContent[indexPath.row]["name"]
        cell.textLabel?.text = cityName
        cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension SelectCityViewController: UITableViewDelegate {
    
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
