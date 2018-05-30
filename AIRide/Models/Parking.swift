//
//  Parking.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 08.05.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import Foundation

class Parking {
    var available_places: Int
    var id: Int
    var latitude: Double
    var longitude: Double
    var places: Int
    var price: Int
    var title: String
    var text: String
    
    init(available_places: Int, id: Int, latitude: Double, longitude: Double, places: Int, price: Int, title: String, text: String) {
        self.available_places = available_places
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.places = places
        self.price = price
        self.title = title
        self.text = text
    }
}
