//
//  Management.swift
//  SuperVarioWohnen
//
//  Created by Max Bause on 25.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import Foundation

struct Management: Decodable {
    let id: String
    let name : String
    let postcode : String
    let place : String
    let street : String
    let phone : String?
    let mail : String?
    let openings_weekdays : String?
    let openings_weekends : String?
}
