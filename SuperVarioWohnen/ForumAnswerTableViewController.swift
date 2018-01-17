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
    var forumPost : ForumPost?

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadForumAnswe()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return forumAnswer.count + 1
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForumAnswerTableViewCell", for: indexPath) as? ForumAnswerTableViewCell else {
            fatalError("Not a Forum Post")
        }
        
        if indexPath.section == 0 {
            cell.userLabel.text = forumPost?.user
            cell.titleLabel.text = forumPost?.title
            cell.answerLabel.text = forumPost?.postText
        }
        else {
            cell.userLabel.text = forumAnswer[indexPath.section - 1].user
            cell.titleLabel.text = forumPost?.title
            cell.answerLabel.text = forumAnswer[indexPath.section - 1].postText
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return forumPost?.date.description
        }
        else {
            return forumAnswer[section - 1].date.description
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func LoadForumAnswe() {
        for _ in 1 ..< 11 {
            guard let forumPost = ForumPost(user: "Gires Ntchouayang", title: "Nicht Wichtig", postText: "Lorem ipsum dolek nomia dilup dlai fgirsup nako riad olem dorek sizou de sizouorem ipsum dolek nomia dilup dlai fgirsup nako riad olem dorek sizou de sizo", date: Date.init())
                else{
                    fatalError("Konnte kein Post erzeugen...")
            }
            forumAnswer += [forumPost]
        }
    }

}
