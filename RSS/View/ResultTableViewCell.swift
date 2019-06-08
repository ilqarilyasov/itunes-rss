//
//  ResultTableViewCell.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Clean up cells before reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        textLabel?.text = nil
        detailTextLabel?.text = nil
        imageView?.image = nil
    }
    
    
    // MARK: - Properties
    
    let loader = ImageLoader()
    
    var result: Result? {
        didSet { updateViews() }
    }
    
    
    // MARK: - Helpers
    
    private func updateViews() {
        guard let result = result else { return }
        
        textLabel?.text = result.artistName
        var text = ""
        
        switch result.kind {
        case .album:
            text = "Album"
        case .iosSoftware:
            text = "iOS App"
        case .movie:
            text = "Movie"
        }
        
        detailTextLabel?.text = "Kind: \(text)"
        
        if let image = result.image {
            self.imageView?.image = image
        } 
    }

}
