//
//  ViewController.swift
//  Backbase
//
//  Created by Paulo Correa on 28/02/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import UIKit
import MapKit

class CityListViewController: UIViewController {
    
    private var tableView: UITableView = UITableView()
    private lazy var mapView: MKMapView = {
        return MKMapView()
    }()
    
    let cellReuseIdentifier = "cellCity"
    
    fileprivate var tableViewPortraitConstraint: NSLayoutConstraint!
    fileprivate var tableViewLandscapeConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cities"
        view.backgroundColor = .white
        
        setupTableView()
        setupLayout()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        if #available(iOS 11.0, *) {
            tableViewPortraitConstraint = tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: nil)
        } else {
            tableViewPortraitConstraint = tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            tableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil)
        }
        
        tableViewLandscapeConstraint = tableView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -55)
        setupOrientation()
    }
    
    private func setupMapView() {
        view.insertSubview(mapView, belowSubview: tableView)
        mapView.anchor(top: view.topAnchor, leading: view.centerXAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0))
    }
    
    private func setupOrientation() {
        if UIDevice.current.orientation.isPortrait {
            NSLayoutConstraint.deactivate([tableViewLandscapeConstraint])
            NSLayoutConstraint.activate([tableViewPortraitConstraint])
        } else {
            if !(mapView.isDescendant(of: view)) {
                setupMapView()
            }
            
            NSLayoutConstraint.deactivate([tableViewPortraitConstraint])
            NSLayoutConstraint.activate([tableViewLandscapeConstraint])
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        setupOrientation()
    }
    
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        }
        
        cell!.textLabel?.text = "City"
        cell!.detailTextLabel?.text = "Detail"
        return cell!
    }
}



