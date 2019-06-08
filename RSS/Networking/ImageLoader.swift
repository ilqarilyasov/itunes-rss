//
//  ImageLoader.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/8/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit

class ImageLoader {
    
    /// Loads an image from a remote URL and loads it to the search results' image data property
    func loadImage(_ searchResult: Result, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: searchResult.artworkUrl100) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            let image = UIImage(data: data)
            searchResult.image = image
            completion(nil)
        }.resume()
    }
}
