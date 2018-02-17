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
    
    var passedImage: UIImage!
    var passedId: String!
    var imageTitle: String!
    
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
                if(self.imageTitle == "") {
                    self.imageTitleLbl.text = "Image Title Not Found"
                }
                else {
                   self.imageTitleLbl.text = self.imageTitle
                }
                
               self.spinner.stopAnimating()
               self.spinner.isHidden = true
            }
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
