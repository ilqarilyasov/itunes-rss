//
//  RSSTableViewController.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit

class RSSTableViewController: UITableViewController {

    private let client = NetworkClient()
    private let loader = ImageLoader()
    private var segmentedControl: UISegmentedControl!
    private var mediaType = MediaType.appleMusic.rawValue
    
    // Holds all of our model objects
    private(set) var searchResults = [Result]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "iTunes RSS"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(ResultTableViewCell.self, forCellReuseIdentifier: "resultCell")
        
        client.fetchRSS { (results, error) in
            if let error = error {
                NSLog("Error performing search: \(error)")
                return
            }
            
            if let results = results {
                self.searchResults = results
                
                results.forEach({ (result) in
                    self.loader.loadImage(result, completion: { (_) in
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                })
                
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        
        guard let resultCell = cell as? ResultTableViewCell else { return cell }
        
        let result = searchResults[indexPath.row]
        resultCell.result = result
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 60)
        let headerView = UIView(frame: frame)
        headerView.backgroundColor = .white
        
        segmentedControl = UISegmentedControl()
        segmentedControl.addTarget(self, action: #selector(didTappedSegmentedControl), for: .valueChanged)
        headerView.addSubview(segmentedControl)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -10).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10).isActive = true
        
        segmentedControl.insertSegment(withTitle: "Apple Music", at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "iOS Apps", at: 1, animated: false)
        segmentedControl.insertSegment(withTitle: "Movies", at: 2, animated: false)
        
        switch mediaType {
        case MediaType.appleMusic.rawValue:
            segmentedControl.selectedSegmentIndex = 0
        case MediaType.iosApps.rawValue:
            segmentedControl.selectedSegmentIndex = 1
        case MediaType.movies.rawValue:
            segmentedControl.selectedSegmentIndex = 2
        default:
            break
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    @objc
    private func didTappedSegmentedControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            mediaType = MediaType.appleMusic.rawValue
            sender.selectedSegmentIndex = 0
        case 1:
            mediaType = MediaType.iosApps.rawValue
            sender.selectedSegmentIndex = 1
        case 2:
            mediaType = MediaType.movies.rawValue
            sender.selectedSegmentIndex = 2
        default:
            break
        }
        
        client.fetchRSS(mediaType: mediaType) { (results, error) in
            if let error = error {
                NSLog("Error performing search: \(error)")
                return
            }
            
            if let results = results {
                self.searchResults = results
                
                results.forEach({ (result) in
                    self.loader.loadImage(result, completion: { (_) in
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    })
                })
            }
        }
    }

}
