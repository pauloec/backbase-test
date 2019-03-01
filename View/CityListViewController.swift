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
    private let viewModel: CityListViewModel
    private var tableView: UITableView = UITableView()
    private var searchBar: UISearchBar = UISearchBar()
    private var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    private lazy var mapView: MKMapView = {
        return MKMapView()
    }()
    
    private let cellReuseIdentifier = "cellCity"
    
    fileprivate var portraitConstraints = [NSLayoutConstraint]()
    fileprivate var landscapeConstraints = [NSLayoutConstraint]()
    
    init(viewModel: CityListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.didSearch = { [weak self] in
            self?.loadingView.stopAnimating()
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
        }
        
        viewModel.willSearch = { [weak self] in
            self?.loadingView.startAnimating()
            self?.tableView.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- UI
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cities"
        view.backgroundColor = .white
        
        setupSearchBar()
        setupTableView()
        setupLoading()
        setupLayout()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        view.addSubview(searchBar)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    private func setupLoading() {
        view.addSubview(loadingView)
        loadingView.anchor(top: searchBar.bottomAnchor, leading: tableView.leadingAnchor, bottom: nil, trailing: nil)
    }
    
    private func setupLayout() {
        if #available(iOS 11.0, *) {
            searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: nil)
            tableView.anchor(top: searchBar.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.bottomAnchor, trailing: nil)
            
            portraitConstraints.append(searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
            portraitConstraints.append(tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor))
        } else {
            searchBar.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil)
            tableView.anchor(top: searchBar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil)
            
            portraitConstraints.append(searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor))
            portraitConstraints.append(tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
        }
        landscapeConstraints.append(searchBar.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -50))
        landscapeConstraints.append(tableView.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -50))
        
        setupOrientation()
    }
    
    private func setupOrientation() {
        if UIDevice.current.orientation.isPortrait {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstraints)
            
            if let selectedIndex = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndex, animated: true)
            }
        } else {
            if !(mapView.isDescendant(of: view)) {
                setupMapView()
            } else {
                mapView.removeAnnotations(mapView.annotations)
            }
            
            NSLayoutConstraint.deactivate(portraitConstraints)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }
    
    private func setupMapView() {
        view.insertSubview(mapView, belowSubview: searchBar)
        mapView.anchor(top: view.topAnchor, leading: view.centerXAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0))
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        setupOrientation()
    }
    
    //MARK:- Private Helpers
    @objc func searchCity() {
        if let text = searchBar.text {
            viewModel.searchCity(input: text)
        }
    }
    
}

//MARK:- Extensions
extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filteredList.count : viewModel.cityList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        }
        
        let city = viewModel.isSearching ? viewModel.filteredList[indexPath.row] : viewModel.cityList[indexPath.row]
        cell!.textLabel?.text = city.title
        cell!.detailTextLabel?.text = city.subtitle
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.isSearching ? viewModel.filteredList[indexPath.row] : viewModel.cityList[indexPath.row]

        if UIDevice.current.orientation.isPortrait {
            let mapViewController = CityMapViewController(cityData: city)
            navigationController?.pushViewController(mapViewController, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            mapView.removeAnnotations(mapView.annotations)

            let coordinate = CLLocationCoordinate2D(latitude: city.latitude, longitude: city.longitude)
            let annotation = MKPointAnnotation()
            annotation.title = city.title
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.setCenter(coordinate, animated: true)
        }
    }
}

extension CityListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // We add some throttling to the search
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchCity), object: nil)
        self.perform(#selector(self.searchCity), with: nil, afterDelay: 0.3)
    }
}


