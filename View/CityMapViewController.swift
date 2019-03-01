//
//  CityMapViewController.swift
//  Backbase
//
//  Created by Paulo Correa on 01/03/19.
//  Copyright © 2019 Paulo Correa. All rights reserved.
//

import UIKit
import MapKit

class CityMapViewController: UIViewController {
    private let mapView: MKMapView = MKMapView()
    private let cityData: CityViewModel
    
    init(cityData: CityViewModel) {
        self.cityData = cityData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- UI
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = cityData.title
        
        setupMapView()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.anchorSuperview()
        
        let coordinate = CLLocationCoordinate2D(latitude: cityData.latitude, longitude: cityData.longitude)
        let annotation = MKPointAnnotation()
        annotation.title = cityData.title
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.setCenter(coordinate, animated: true)
    }

}
