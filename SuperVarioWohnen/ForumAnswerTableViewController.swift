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
    let forumPostUrl = "https://thecodelabs.de:2530/forum/1/"

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
        let dateString = dateFormatterGerman.string(from: forumAnswer[0].date)
        
        return dateString
    }
    
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ForumAnswerTableViewCell
        print("ZellenFrame: \(cell.userLabel.frame)")
        
    }

    /*
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ForumAnswerTableViewCell
        print("ZellenFrameDeselect: \(cell.userLabel.frame)")
    }*/
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
        if segue.identifier == "neueAntWortIdentifier" {
            let destinationViewController = segue.destination as! NewReplyViewController
            destinationViewController.id = forumAnswer[0].id.description
        }
    }
    
    
    func LoadForumAnswer() {
        
        let url = forumPostUrl + forumAnswer[0].id.description
        
        var request = URLRequest(url: URL(string: url)!)
        request.setValue("ztiuohijopk", forHTTPHeaderField: "auth")
        request.httpMethod = "GET"
        
        let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                    if (jsonObject?.isEmpty)!{
                        return
                    }
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
                            let title = self.forumAnswer[0].title
                            let message = postElmt["message"] as! String
                            let id = postElmt["id"] as! Int
                            guard let forumpost = ForumPost(id: id, user: user, title: title, postText: message, date: date)
                                else{
                                    fatalError("Fehler bei der Instanziierung von Post Objekte!!")
                            }
                            /*print(user)
                             print(title)
                             print(message)
                             print(date)*/
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
        
        /*for _ in 1 ..< 11 {
            guard let forumPost = ForumPost(user: "Gires Ntchouayang", title: "Nicht Wichtig", postText: "Lorem ipsum dolek nomia dilup dlai fgirsup nako riad olem dorek sizou de sizouorem ipsum dolek nomia dilup dlai fgirsup nako riad olem dorek sizou de sizo", date: Date.init())
                else{
                    fatalError("Konnte kein Post erzeugen...")
            }
            forumAnswer += [forumPost]
        }*/
    }

}
