//
//  BoardTableViewController.swift
//  SuperVarioWohnen
//
//  Created by Tobias on 28.01.18.
//  Copyright © 2018 Tobias. All rights reserved.
//

import UIKit

class BoardTableViewController: UITableViewController {
    
    private let url = "https://thecodelabs.de:2530/board"
    
    @IBOutlet weak var toggleButton: UISegmentedControl!
    var entries = [Board]()
    var selectedEntry = 0
    var showUnReadEntries = true
    
    var readedEntries = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("entries.json")
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
            
            for element in json {
                if let id = element as? Int {
                    readedEntries.insert(id)
                }
            }
        } catch {
            print(error)
        }
        
        title = "Neugkeiten"
        
        loadBoardData()
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
        return entryFiltered.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath)
        
        if let cell = cell as? BoardTableViewCell {
            let board = entryFiltered[indexPath.row]
            
            cell.titleLabel.text = board.title
            cell.messageLabel.text = board.message
            cell.messageLabel.sizeToFit()
            
            cell.makerImageView.isHidden = readedEntries.contains(board.id)
            
            let dateFormatterGerman = DateFormatter()
            dateFormatterGerman.dateFormat = "dd.MM.YYYY"
            let dateString = dateFormatterGerman.string(from: board.createDate)
            cell.dateLabel.text = dateString
        }
        
        return cell
    }
    
    @IBAction func toggleButtonHandler(_ sender: Any) {
        if toggleButton.selectedSegmentIndex == 0 {
            showUnReadEntries = true
        } else if toggleButton.selectedSegmentIndex == 1 {
            showUnReadEntries = false
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEntry = indexPath.row
        if let cell = tableView.cellForRow(at: indexPath) as? BoardTableViewCell {
            cell.makerImageView.isHidden = true
            readedEntries.insert(entryFiltered[indexPath.row].id)
            
            performSegue(withIdentifier: "entryDetailSegue", sender: self)
            
            do {
                try saveReadedIds()
            } catch {
                print(error)
            }
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "entryDetailSegue" {
            if let destinationViewController = segue.destination as? BoardEntryViewController {
                destinationViewController.entry = entryFiltered[selectedEntry]
            }
        }
    }
    
    
    func loadBoardData() {
        if let token = try? getQrCode() {
            
            if let url = URL(string: self.url) {
                let payload = Data()
                var request = URLRequest(url:url)
                request.httpMethod = "GET"
                request.setValue(token, forHTTPHeaderField: "auth")
                request.httpBody = payload
                
                self.entries = []
                
                let session = URLSession(configuration: URLSessionConfiguration.default)
                let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
                    do {
                        if let data = data {
                            print(data)
                            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String:Any]]
                            for entry in json {
                                guard let title = entry["title"] as? String else {
                                    continue
                                }
                                guard let id = entry["id"] as? Int else {
                                    continue
                                }
                                guard let message = entry["message"] as? String else {
                                    continue
                                }
                                guard let createDate = entry["createDate"] as? String else {
                                    continue
                                }
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                                let date = dateFormatter.date(from: createDate)!
                                
                                self.entries.append(Board(id: id, title: title, message: message, createDate: date))
                            }
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                })
                task.resume()
            }
        }
    }
    
    var entryFiltered: [Board] {
        if (showUnReadEntries) {
            return entries
        } else {
            return entries.filter {
                !self.readedEntries.contains($0.id)
            }
        }
    }
    
    func saveReadedIds() throws {
        let url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("entries.json")
        
        let json = try JSONSerialization.data(withJSONObject: Array(readedEntries), options: .prettyPrinted)
        try json.write(to: url)
    }
}
