//
//  Image.swift
//  SuperVarioWohnen
//
//  Created by Mac on 29.12.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import Foundation

class Image: NSObject
{
    private let id: String
    private let link: String
    
    let title: String
    
    init(id: String, title: String, link: String) {
        
        self.id = id
        self.title = title
        self.link = link
    }
}
