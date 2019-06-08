//
//  NetworkClient.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import UIKit

class NetworkClient {
    
    // Holds the base URL for the iTunes RSS API
    private let baseURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/")!    
    
    /// Performs a network call to the iTunes RSS API with the given media type and result limit.
    func fetchRSS(mediaType: String = "apple-music", resultLimit: Int = 25,
                       completion: @escaping ([Result]?, Error?) -> Void) {
        
        // If mediaType is Apple Musics use 'coming-soon if it's Movies use 'top-movies'
        var feedType = "coming-soon"
        
        switch mediaType {
        case MediaType.appleMusic.rawValue:
            feedType = "coming-soon"
        case MediaType.iosApps.rawValue:
            feedType = "new-apps-we-love"
        case MediaType.movies.rawValue:
            feedType = "top-movies"
        default:
            break
        }
        
        // Make url
        let url = baseURL.appendingPathComponent(mediaType)
            .appendingPathComponent(feedType)
            .appendingPathComponent("all")
            .appendingPathComponent("\(resultLimit)")
            .appendingPathComponent("explicit")
            .appendingPathExtension("json")
        
        // Make a valid url request
        let requestURL = URLRequest(url: url)
        
        // Start the data task
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            // If there is an error, log it and give it to the completion handler
            if let error = error {
                NSLog("Error fetching data: \(error)")
                completion(nil, error)
                return
            }
            
            // If there is no data, log it and return an error to the completion handler
            guard let data = data else {
                NSLog("Error. No data.")
                completion(nil, NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                // If the data can be decoded, set the results to it and call the completion handler
                let rss = try jsonDecoder.decode(Feed.self, from: data)
                completion(rss.results, nil)
                
            } catch {
                // If not, log the error and pass it to the completion handler
                NSLog("Error decoding data: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
}
