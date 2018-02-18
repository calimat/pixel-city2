//
//  PopVC.swift
//  pixel-city
//
//  Created by Ricardo Herrera Petit on 2/16/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import UIKit
import Alamofire
import MapKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var popImageView: UIImageView!
    @IBOutlet weak var imageTitleLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var postedDateLbl: UILabel!
    
    @IBOutlet weak var imgDescriptionLbl: UILabel!
    
    var passedImage: UIImage!
    var passedId: String!
    var imageTitle: String!
    var imageDescription: String!
    var imagePostedDate: String!
    var imageLongitude: String!
    var imageLatitude: String!
    let regionRadius:Double = 1000
    
    func initData(forImage image: UIImage, andImageId id: String) {
        self.passedImage = image
        self.passedId = id 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        mapView.delegate = self 
        popImageView.image = passedImage
        addDoubleTap()
        updateView()
    }
    
    func centerMapOnUserLocation(ForCoordinate coordinate: CLLocationCoordinate2D) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius * 2.0 , regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func updateView() {
        retrieveImageInfo { (finished) in
            if finished {
                
                self.imageTitleLbl.text =  self.checkIfTextIsNotEmpty(textToBeChecked: self.imageTitle, defaultTextIfEmpty: "Image Title Not Found")
                self.imgDescriptionLbl.text = self.checkIfTextIsNotEmpty(textToBeChecked: self.imageDescription, defaultTextIfEmpty: "Description not found or empty")
                
                guard let date = self.imagePostedDate else { return }
                self.convert(FromString: date)
                
                self.setMapImageLocatinFor(Latitude: Double(self.imageLatitude)!, andLongitude: Double(self.imageLongitude)!)
              
                
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        }
    }
    
    func setMapImageLocatinFor(Latitude lat:Double, andLongitude lon:Double) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
          self.centerMapOnUserLocation(ForCoordinate: annotation.coordinate)
        mapView.addAnnotation(annotation)
    }
    
    
    func convert(FromString unixTimeStamp: String)  {
    
        let date = Date(timeIntervalSince1970: Double(unixTimeStamp)!)
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM, dd yyyy  h:mm a"
        let finalDate = newFormatter.string(from: date)
        postedDateLbl.text = "Posted on: \(finalDate)"
    }
    
    func checkIfTextIsNotEmpty(textToBeChecked: String,defaultTextIfEmpty: String) -> String {
        if textToBeChecked == "" {
            return defaultTextIfEmpty;
        } else {
            return textToBeChecked
        }
    }
    
    func retrieveImageInfo(handler: @escaping (_ status:Bool) -> ()) {
        spinner.isHidden = false
        spinner.startAnimating()
        Alamofire.request(flikrUrlgetInfo(forApiKey: apiKey, withImageId: self.passedId)).responseJSON { (response) in
            guard let json = response.result.value as? Dictionary<String, Any> else { return }
            guard let photoInfo = json["photo"] as? Dictionary<String,Any> else { return }
            print(json["photo"]!)
            guard let titleinfo = photoInfo["title"] as? Dictionary<String, String> else { return }
            guard let description = photoInfo["description"] as? Dictionary<String, String> else { return }
            guard let dates = photoInfo["dates"] as? Dictionary<String,String> else { return }
            guard let postedDate = dates["posted"] else { return }
            guard let location = photoInfo["location"] as? Dictionary<String, Any> else { return }
            guard let latitude = location["latitude"] as? String else { return }
            guard let longitude = location["longitude"] as? String else { return }
            
            
            guard let descriptionInfo =  description["_content"] else { return }
            
            self.imageDescription = descriptionInfo
            self.imagePostedDate = postedDate
            self.imageLongitude = longitude
            self.imageLatitude = latitude
            
            
            if let title = titleinfo["_content"] {
                self.imageTitle = title
            } else {
                self.imageTitle = "No title for image"
            }
            
            
            
            handler(true)
            
        }
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc func screenWasDoubleTapped() {
        dismiss(animated: true, completion: nil)
    }
 
   
    
    
    
}

extension PopVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "dropabblePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
}


