//
//  ResultTableViewCell.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    
    var result: Result? {
        didSet { updateViews() }
    }
    
    private func updateViews() {
        guard let result = result else { return }
        
        textLabel?.text = result.artistName
        detailTextLabel?.text = "Kind: \(result.kind.rawValue.capitalized)"
        
        if let imageData = result.imageData {
            imageView?.image = UIImage(data: imageData)
        }
    }

}
