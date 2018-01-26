//
//  Document.swift
//  SuperVarioWohnen
//
//  Created by Tobias on 26.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import Foundation

class Document {
    let id: Int
    let name: String
    let folderName: String
    
    init(id: Int, name: String, folderName: String) {
        self.id = id
        self.name = name
        self.folderName = folderName
    }
}
