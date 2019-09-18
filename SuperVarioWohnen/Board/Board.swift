//
//  Board.swift
//  SuperVarioWohnen
//
//  Created by Tobias on 28.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import Foundation

struct Board: Decodable {
    
    let id : Int
    
    let title: String
    let message: String
    let createDate: Date
}
