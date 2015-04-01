//
//  YALMainViewController.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

private let kShowDetailSegueId = "showDetailSegueId"

class YALMainViewController: YALBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var indicatorView: UIActivityIndicatorView?
    
    private var cities: NSArray = []
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        updateData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowDetailSegueId {
            
            let selectedRows: NSArray? = self.tableView?.indexPathsForSelectedRows()
            let selectedIndexPath: NSIndexPath = selectedRows?.lastObject as NSIndexPath
            
            let detailedVC = segue.destinationViewController as YALDetailedViewController
            detailedVC.city = self.cities[selectedIndexPath.item] as YALCity
        }
    }
    
    // MARK: Private
    private func setupView() {
        let cellNib: UINib = UINib(nibName: YALCityTableViewCell.nibName(), bundle: nil) as UINib
        self.tableView?.registerNib(cellNib, forCellReuseIdentifier: YALCityTableViewCell.reuseIdentifier())
    }
    
    private func updateData() {
        shouldAnimateIndicator(true)
        YALCloudKitManager.fetchAllCitiesWithCompletionHandler { [weak self] (records, error) -> Void in
            
            self?.shouldAnimateIndicator(false)
            
            if error == nil {
                if records.count == 0 {
                    self?.presentMessage("Add City from the default list. Database is empty")
                    return
                }
                
                self?.cities = records
                self?.tableView?.reloadData()
            } else {
                self?.presentMessage(error.localizedDescription)
            }
        }
    }
    
    private func addCity(city: YALCity) {
        var temp = NSMutableArray.init()
        temp.addObjectsFromArray(self.cities)
        temp.insertObject(city, atIndex: 0)
        self.cities = temp
        self.tableView?.reloadData()
    }
    
    private func removeCity(city: YALCity) {
        var temp = NSMutableArray.init()
        temp.addObjectsFromArray(self.cities)
        temp.removeObject(city)
        self.cities = temp
        self.tableView?.reloadData()
    }
    
    private func shouldAnimateIndicator(animate: Bool) {
        if animate {
            self.indicatorView?.startAnimating()
        } else {
            self.indicatorView?.stopAnimating()
        }
        
        self.tableView?.userInteractionEnabled = !animate
        self.navigationController?.navigationBar.userInteractionEnabled = !animate
    }
    
    // MARK: IBActions
    @IBAction func unwindToMainViewController(segue:UIStoryboardSegue) {
        if segue.sourceViewController.isMemberOfClass(YALSelectCityViewController) {
            let selectCityVC = segue.sourceViewController as YALSelectCityViewController
            addCity(selectCityVC.selectedCity)
        } else if segue.sourceViewController.isMemberOfClass(YALDetailedViewController) {
            let detailedVC = segue.sourceViewController as YALDetailedViewController
            removeCity(detailedVC.city)
        }
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: YALCityTableViewCell = tableView.dequeueReusableCellWithIdentifier(YALCityTableViewCell.reuseIdentifier()) as YALCityTableViewCell
        
        let city = self.cities[indexPath.row] as YALCity
        cell.setCity(city)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(kShowDetailSegueId, sender: self)
    }
}
