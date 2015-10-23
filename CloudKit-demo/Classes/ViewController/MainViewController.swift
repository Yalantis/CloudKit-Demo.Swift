//
//  YALMainViewController.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

private let kShowDetailSegueId = "showDetailSegueId"

class MainViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var indicatorView: UIActivityIndicatorView!
    
    private var cities = [City]()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        CloudKitManager.checkLoginStatus {
            self.updateData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kShowDetailSegueId {
            
            let selectedRows: [NSIndexPath] = self.tableView.indexPathsForSelectedRows!
            let selectedIndexPath = selectedRows.last
            
            let detailedVC = segue.destinationViewController as! DetailedViewController
            detailedVC.city = self.cities[selectedIndexPath!.row]
        }
    }
    
    // MARK: Private
    private func setupView() {
        let cellNib = UINib(nibName: CityTableViewCell.nibName(), bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: CityTableViewCell.reuseIdentifier())
        tableView.tableFooterView = UIView()
    }
    
    private func updateData() {
        shouldAnimateIndicator(true)
        
        CloudKitManager.fetchAllCities { (records, error) in
            self.shouldAnimateIndicator(false)
            
            guard let cities = records else {
                self.presentMessage(error.localizedDescription)
                return
            }
            
            guard !cities.isEmpty else {
                self.presentMessage("Add City from the default list. Database is empty")
                return
            }
            
            self.cities = cities
            self.tableView.reloadData()
        }
    }
    
    private func addCity(city: City) {
        cities.insert(city, atIndex: 0)
        tableView.reloadData()
    }
    
    private func removeCity(city: City) {
        cities = self.cities.filter { (current: City) -> Bool in
            return current != city
        }
        tableView.reloadData()
    }
    
    private func shouldAnimateIndicator(animate: Bool) {
        if animate {
            self.indicatorView.startAnimating()
        } else {
            self.indicatorView.stopAnimating()
        }
        
        self.tableView?.userInteractionEnabled = !animate
        self.navigationController?.navigationBar.userInteractionEnabled = !animate
    }
    
    // MARK: IBActions
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {
        if let source = segue.sourceViewController as? SelectCityViewController {
            addCity(source.selectedCity)
        } else if let source = segue.sourceViewController as? DetailedViewController {
            removeCity(source.city)
        }
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CityTableViewCell.reuseIdentifier()) as! CityTableViewCell
        
        let city = self.cities[indexPath.row]
        cell.setCity(city)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(kShowDetailSegueId, sender: self)
    }
}
