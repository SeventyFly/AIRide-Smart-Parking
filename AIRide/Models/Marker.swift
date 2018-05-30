//
//  Marker.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 29.04.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import Foundation

class Marker {
    var id:Int
    var image:String
    var latitude:Double
    var longitude:Double
    var price:Int
    var street:String
    var text:String
    
    init(id:Int, image:String, latitude:Double, longitude:Double, price:Int, street:String, text:String) {
        self.id = id
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
        self.price = price
        self.street = street
        self.text = text
    }
}
