//
//  ForumAnswerTableViewController.swift
//  SuperVarioWohnen
//
//  Created by Ntchouayang Nzeunga, Gires on 12.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit

class ForumAnswerTableViewController: UITableViewController {
    
    //MARK
    var forumAnswer = [ForumPost]()
    
    var forumCategory: ForumCategory?
    var forumPost: ForumPost?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 140
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoadForumAnswer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forumAnswer.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        /*if section == 0 {
         return 1
         }
         else {
         return forumAnswer.count
         }*/
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForumAnswerTableViewCell", for: indexPath) as! ForumAnswerTableViewCell
        
        cell.userLabel.text = forumAnswer[indexPath.section].user
        cell.titleLabel.text = forumAnswer[0].title
        cell.answerLabel.text = forumAnswer[indexPath.section].postText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatterGerman = DateFormatter()
        dateFormatterGerman.dateFormat = "dd.MM.YYYY HH:mm"
        let dateString = dateFormatterGerman.string(from: forumAnswer[section].date)
        
        return dateString
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ForumAnswerTableViewCell
        print("ZellenFrame: \(cell.userLabel.frame)")
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "neueAntWortIdentifier" {
            let destinationViewController = segue.destination as! NewReplyViewController
            destinationViewController.id = forumAnswer[0].id.description
        }
    }
    
    
    func LoadForumAnswer() {
        if let category = forumCategory, let post = forumPost, let url = getUrl(endPoint: "/forum/\(category.id)/\(post.id)"), let token = try? getQrCode() {
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField: "auth")
            request.httpMethod = "GET"
            
            let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                        if (jsonObject?.isEmpty)!{
                            return
                        }
                        if let json = jsonObject as? [[String: Any]] {
                            for postElmt in json {
                                let datestr = postElmt["date"] as! String
                                let dateformatter = DateFormatter()
                                dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                let date = dateformatter.date(from: datestr)!
                                let tenant = postElmt["tenant"] as! [String : Any]
                                let name = tenant["name"] as! String
                                let lastname = tenant["lastName"] as! String
                                let user = name + " " + lastname
                                let title = self.forumAnswer[0].title
                                let message = postElmt["message"] as! String
                                let id = postElmt["id"] as! Int
                                guard let forumpost = ForumPost(id: id, user: user, title: title, postText: message, date: date)
                                    else{
                                        fatalError("Fehler bei der Instanziierung von Post Objekte!!")
                                }
                                self.forumAnswer += [forumpost]
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
