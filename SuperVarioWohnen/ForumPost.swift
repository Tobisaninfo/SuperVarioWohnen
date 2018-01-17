//
//  ForumPost.swift
//  SuperVarioWohnen
//
//  Created by Xen on 20.12.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit

class ForumPost {
    
    //MARK: Properties
    
    var user: String
    var title: String
    var postText: String
    var date: Date
    
    //MARK: Initialization
    
    init?(user: String, title: String, postText: String, date: Date) {
        if user.isEmpty || postText.isEmpty {
            return nil
        }
        self.user = user
        self.title = title
        self.postText = postText
        self.date = date
    }
}
