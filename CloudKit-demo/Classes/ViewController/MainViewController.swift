//
//  YALMainViewController.swift
//  CloudKit-demo
//
//  Created by Maksim Usenko on 3/25/15.
//  Copyright (c) 2015 Yalantis. All rights reserved.
//

import UIKit

private let kShowDetailSegueId = "showDetailSegueId"

class MainViewController: BaseViewController {
    
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
            let selectedRows = tableView.indexPathsForSelectedRows!
            let selectedIndexPath = selectedRows.last!
            let detailedVC = segue.destination as! DetailedViewController
            detailedVC.city = cities[selectedIndexPath.row]
        }
    }
}

// MARK: Private
fileprivate extension MainViewController {
    
    func setupView() {
        let cellNib = UINib(nibName: CityTableViewCell.nibName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: CityTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    func updateData() {
        shouldAnimateIndicator(true)
        
        CloudKitManager.fetchAllCities { [weak self] records, error in
            guard let self = self else { return }
            
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
    
    func addCity(_ city: City) {
        cities.insert(city, at: 0)
        tableView.reloadData()
    }
    
    func removeCity(_ cityToRemove: City) {
        cities = cities.filter { currentCity in
            return currentCity != cityToRemove
        }
        tableView.reloadData()
    }
    
    func shouldAnimateIndicator(_ animate: Bool) {
        if animate {
            indicatorView.startAnimating()
        } else {
            indicatorView.stopAnimating()
        }
        
        tableView.isUserInteractionEnabled = !animate
        navigationController?.navigationBar.isUserInteractionEnabled = !animate
    }
}

// MARK: IBActions
extension MainViewController {
    
    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
        if let source = segue.source as? SelectCityViewController {
            addCity(source.selectedCity)
        } else if let source = segue.source as? DetailedViewController {
            removeCity(source.city)
        }
        
        _ = navigationController?.popToViewController(self, animated: true)
    }
    
    @IBAction func reloadCities() {
        shouldAnimateIndicator(true)
        CloudKitManager.checkLoginStatus { [weak self] isLogged in
            guard let self = self else { return }
            
            self.shouldAnimateIndicator(false)
            if isLogged {
                self.updateData()
            } else {
                print("account unavailable")
                self.settingsAlert()
            }
        }
    }
}

// MARK: UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTableViewCell.reuseIdentifier) as! CityTableViewCell
        let city = cities[indexPath.row]
        cell.setCity(city)
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: kShowDetailSegueId, sender: self)
    }
}

// MARK: - Alert

private extension MainViewController {
    
    func settingsAlert() {
        let alert = UIAlertController(title: "iCloud", message: "iCloud is unavailable, please login into your Apple id and try again!", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let url = URL(string:"App-Prefs:root=General") else { return }
            UIApplication.shared.openURL(url)
        }
        
        alert.addAction(cancel)
        alert.addAction(settings)
        
        present(alert, animated: true)
    }
}
