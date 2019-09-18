//
//  ForumTableViewController.swift
//  SuperVarioWohnen
//
//  Created by Tobias on 11.02.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit

class ForumTableViewController: UITableViewController {

    private var categories = [ForumCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "entrySegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "entrySegue", let destinationController = segue.destination as? ForumPostTableViewController {
            if let selected = tableView.indexPathForSelectedRow {
                destinationController.category = categories[selected.row]
            }
        }
    }
    
    private func loadData() {
        self.categories = []
        if let token = try? getQrCode() {
            let url = URL(string: "https://thecodelabs.de:2530/forum")!
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField: "auth")
            request.httpMethod = "GET"
            
            let session = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
                        if let json = jsonObject as? [[String:Any]] {
                            for elem in json {
                                self.categories.append(ForumCategory(id: elem["id"] as! Int, name: elem["name"] as! String))
                            }
                            DispatchQueue.main.sync {
                                self.tableView.reloadData()
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            }
            session.resume()
        }
    }

}
