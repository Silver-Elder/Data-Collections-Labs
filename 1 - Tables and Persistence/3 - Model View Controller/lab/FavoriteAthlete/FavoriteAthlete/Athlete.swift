//
//  Athlete.swift
//  FavoriteAthlete
//
//  Created by Sterling Jenkins on 10/12/22.
//

import Foundation

// This is my ModelControler!

    // And this (vvv) is my Model!
struct Athlete: CustomStringConvertible {
    var name: String
    var age: Int
    var league: String
    var team: String
    
    var description: String {
        return "\(name) is \(age) years old and plays for the \(team) in the \(league)."
    }
}
