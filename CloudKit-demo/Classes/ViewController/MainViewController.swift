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
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var indicatorView: UIActivityIndicatorView!
    
    fileprivate var cities = [City]()
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        reloadCities()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kShowDetailSegueId {
            
            let selectedRows: [IndexPath] = self.tableView.indexPathsForSelectedRows!
            let selectedIndexPath = selectedRows.last
            
            let detailedVC = segue.destination as! DetailedViewController
            detailedVC.city = self.cities[(selectedIndexPath! as NSIndexPath).row]
        }
    }
    
    // MARK: Private
    fileprivate func setupView() {
        let cellNib = UINib(nibName: CityTableViewCell.nibName(), bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CityTableViewCell.reuseIdentifier())
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func reloadCities() {
        shouldAnimateIndicator(true)
        CloudKitManager.checkLoginStatus { isLogged in
            self.shouldAnimateIndicator(false)
            if isLogged {
                self.updateData()
            } else {
                print("account unavailable")
            }
        }
    }
    
    fileprivate func updateData() {
        shouldAnimateIndicator(true)
        
        CloudKitManager.fetchAllCities { (records, error) in
            self.shouldAnimateIndicator(false)
            
            guard let cities = records else {
                self.presentMessage(error!.localizedDescription)
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
    
    fileprivate func addCity(_ city: City) {
        cities.insert(city, at: 0)
        tableView.reloadData()
    }
    
    fileprivate func removeCity(_ city: City) {
        cities = self.cities.filter { (current: City) -> Bool in
            return current != city
        }
        tableView.reloadData()
    }
    
    fileprivate func shouldAnimateIndicator(_ animate: Bool) {
        if animate {
            self.indicatorView.startAnimating()
        } else {
            self.indicatorView.stopAnimating()
        }
        
        self.tableView?.isUserInteractionEnabled = !animate
        self.navigationController?.navigationBar.isUserInteractionEnabled = !animate
    }
    
    // MARK: IBActions
    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
        if let source = segue.source as? SelectCityViewController {
            addCity(source.selectedCity)
        } else if let source = segue.source as? DetailedViewController {
            removeCity(source.city)
        }
        
        self.navigationController?.popToViewController(self, animated: true)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifier()) as! CityTableViewCell
        
        let city = self.cities[(indexPath as NSIndexPath).row]
        cell.setCity(city)
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kShowDetailSegueId, sender: self)
    }
}
