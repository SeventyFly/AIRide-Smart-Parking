//
//  User.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 08.05.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import Foundation

class User {
    var username: String
    var password: String
    var email: String
    var balance: String
    var id: Int
    
    init(username: String, password: String, email: String, balance: String, id: Int) {
        self.username = username
        self.password = password
        self.email = email
        self.balance = balance
        self.id = id
    }
}
