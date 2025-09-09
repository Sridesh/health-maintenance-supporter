//
//  User.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-03.
//

import SwiftData

@Model
class User{
    @Attribute(.unique) var email: String
    var password: String
    var height: Int
    var gender: String
    var weight: Int
    var age: Int
    var isBiometricsAllowed : Bool
    
    init(email: String, password: String, gender:String ,height: Int, weight: Int, age: Int,  isBiometricsAllowed: Bool) {
        self.email = email
        self.password = password
        self.isBiometricsAllowed = isBiometricsAllowed
        self.age = age
        self.weight = weight
        self.height = height
        self.gender = gender
    }
}


