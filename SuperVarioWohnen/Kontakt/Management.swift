//
//  Management.swift
//  SuperVarioWohnen
//
//  Created by Max Bause on 25.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import Foundation

struct Management: Decodable {
    let id: Int
    let name : String
    let postcode : String
    let place : String
    let street : String
    let telefon : String?
    let mail : String?
    let openings_weekdays : String?
    let openings_weekends : String?
    let website: String?
}
