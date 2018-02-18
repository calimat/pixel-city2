//
//  PopVC.swift
//  pixel-city
//
//  Created by Ricardo Herrera Petit on 2/16/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import UIKit
import Alamofire

class PopVC: UIViewController, UIGestureRecognizerDelegate {
    
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
    
    func initData(forImage image: UIImage, andImageId id: String) {
        self.passedImage = image
        self.passedId = id 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        popImageView.image = passedImage
        addDoubleTap()
        updateView()
    }
    
    func updateView() {
        retrieveImageInfo { (finished) in
            if finished {
                
                self.imageTitleLbl.text =  self.checkIfTextIsNotEmpty(textToBeChecked: self.imageTitle, defaultTextIfEmpty: "Image Title Not Found")
                self.imgDescriptionLbl.text = self.checkIfTextIsNotEmpty(textToBeChecked: self.imageDescription, defaultTextIfEmpty: "Description not found or empty")
                
                guard let date = self.imagePostedDate else { return }
                print("Date is: \(date)")
                self.convert(FromString: date)
                
                
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
            }
        }
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
            print(photoInfo)
            guard let titleinfo = photoInfo["title"] as? Dictionary<String, String> else { return }
            guard let description = photoInfo["description"] as? Dictionary<String, String> else { return }
            guard let dates = photoInfo["dates"] as? Dictionary<String,String> else { return }
            guard let postedDate = dates["posted"] else { return }
            
            
            
            guard let descriptionInfo =  description["_content"] else { return }
            
            self.imageDescription = descriptionInfo
            self.imagePostedDate = postedDate
            
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
