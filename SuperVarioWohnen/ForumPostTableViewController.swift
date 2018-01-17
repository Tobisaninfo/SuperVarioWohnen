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
    let url = URL(string: "https://thecodelabs.de:2530/forum/1")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadForumPost()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationViewController = segue.destination as! ForumAnswerTableViewController
                destinationViewController.forumPost = forumPosts[indexPath.row]
            }
        }
    }
    
    
    //MARK: Private Methods
    private func loadForumPost() {
        /*var request = URLRequest(url: url!)
        request.setValue("ztiuohijopk", forHTTPHeaderField: "auth")
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                    if let json = jsonObject {
                        for index in 0...json.count-1{
                            let postElmt = json[index] as! [String : Any]
                            let datestr = postElmt["date"] as! String
                            let dateformatter = DateFormatter()
                            dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                            let date = dateformatter.date(from: datestr)!
                            let tenant = postElmt["tenant"] as! [String : Any]
                            let name = tenant["name"] as! String
                            let lastname = tenant["lastName"] as! String
                            let user = name + " " + lastname
                            let title = postElmt["title"] as! String
                            let message = postElmt["message"] as! String
                            guard let forumpost = ForumPost(user: user, title: title, postText: message, date: date)
                                else{
                                    fatalError("Fehler bei der Instanziierung von Post Objekte!!")
                            }
                            /*print(user)
                            print(title)
                            print(message)
                            print(date)*/
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
        session.resume()*/
        for _ in 1 ..< 11 {
            guard let forumPost = ForumPost(user: "Gires Ntchouayang", title: "Hier ist der Titel", postText: "Lorem ipsum dolek nomia dilup dlai fgirsup nako riad olem dorek sizou de sizouorem ipsum dolek nomia dilup dlai fgirsup nako riad olem dorek sizou de sizo", date: Date.init())
                else{
                    fatalError("Konnte kein Post erzeugen...")
            }
            forumPosts += [forumPost]
        }
    }

}
