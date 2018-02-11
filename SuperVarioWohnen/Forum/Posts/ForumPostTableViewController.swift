//
//  ForumPostTableViewController.swift
//  SuperVarioWohnen
//
//  Created by Xen on 03.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit

class ForumPostTableViewController: UITableViewController {
    
    //MARK: Properties
    var forumPosts = [ForumPost]()
    var category: ForumCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadForumPost()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return forumPosts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ForumPostTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ForumPostTableViewCell else {
            fatalError("Is Kein Instanz von Forum...")
        }
        let post = forumPosts[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = post.user
        cell.titleLabel.text = post.title
        cell.postLabel.text = post.postText
        
        let dateFormatterGerman = DateFormatter()
        dateFormatterGerman.dateFormat = "dd.MM.YYYY HH:mm"
        let dateString = dateFormatterGerman.string(from: post.date)
        cell.dateLabel.text = dateString
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! ForumAnswerTableViewController
                destinationViewController.forumAnswer += [forumPosts[indexPath.row]]
                
                destinationViewController.forumCategory = category
                destinationViewController.forumPost = forumPosts[indexPath.row]
            }
        } else if segue.identifier == "newPostSegue", let destinationController = segue.destination as? NewPostViewController {
            destinationController.category = category
        }
    }
    
    //MARK: Private Methods
    private func loadForumPost() {
        forumPosts = []
        if let token = try? getQrCode(), let category = category, let url = getUrl(endPoint: "/forum/\(category.id)") {
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField: "auth")
            request.httpMethod = "GET"
            
            let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                        if let json = jsonObject as? [[String:Any]] {
                            for postElmt in json {
                                let datestr = postElmt["date"] as! String
                                let dateformatter = DateFormatter()
                                dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                let date = dateformatter.date(from: datestr)
                                let tenant = postElmt["tenant"] as! [String : Any]
                                let name = tenant["name"] as! String
                                let lastname = tenant["lastName"] as! String
                                let user = name + " " + lastname
                                let title = postElmt["title"] as! String
                                let message = postElmt["message"] as! String
                                let id = postElmt["id"] as! Int
                                guard let forumpost = ForumPost(id: id, user: user, title: title, postText: message, date: date!)
                                    else{
                                        fatalError("Fehler bei der Instanziierung von Post Objekte!!")
                                }
                                self.forumPosts += [forumpost]
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            session.resume()
        }
    }
}
