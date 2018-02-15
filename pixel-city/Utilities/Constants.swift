//
//  Constants.swift
//  pixel-city
//
//  Created by Ricardo Herrera Petit on 2/14/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import Foundation

let apiKey = "18f15a4431234c48f74cbc933f23c98d"

func flickrUrl(forApiKey key: String , withAnnotation annotation: DroppablePin, andNumberOfPhotos number:Int) -> String {
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(number)&format=json&nojsoncallback=1"
}


