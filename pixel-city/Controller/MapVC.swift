//
//  ViewController.swift
//  pixel-city
//
//  Created by Ricardo Herrera Petit on 2/13/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
    }
    
    
}

extension MapVC: MKMapViewDelegate {
    
}
