//
//  RSSTableViewController.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit

class RSSTableViewController: UITableViewController {

    let client = NetworkClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "iTunes RSS"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "resultCell")
        
        client.fetchRSS { (error) in
            if let error = error {
                NSLog("Error performing search: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            // Have the search result controller load the image on each result
            for result in self.client.searchResults {
                self.client.loadImage(result, completion: { (error) in
                    if let error = error {
                        NSLog("Error loading image: \(error)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return client.searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        guard let resultCell = cell as? ResultTableViewCell else { return cell }
        
        let result = client.searchResults[indexPath.row]
        resultCell.result = result
        
        return cell
    }

}
