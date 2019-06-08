//
//  NetworkClient.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import Foundation

class NetworkClient {
    
    // Holds the base URL for the iTunes RSS API
    private let baseURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/")!
    
    // Holds all of our model objects
    private(set) var searchResults: [Result] = []
    
    
    /// Performs a network call to the iTunes RSS API with the given media type and result limit.
    func fetchRSS(mediaType: String = "apple-music", resultLimit: Int = 25,
                       completion: @escaping (Error?) -> Void) {
        
        // If mediaType is Apple Musics use 'coming-soon if it's Movies use 'top-movies'
        let feedType = mediaType == "apple-music" ? "coming-soon" : "top-movies"
        
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
                completion(error)
                return
            }
            
            // If there is no data, log it and return an error to the completion handler
            guard let data = data else {
                NSLog("Error. No data.")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                // If the data can be decoded, set the results to it and call the completion handler
                let rss = try jsonDecoder.decode(Feed.self, from: data)
                self.searchResults = rss.results
                completion(nil)
                
            } catch {
                // If not, log the error and pass it to the completion handler
                NSLog("Error decoding data: \(error)")
                completion(error)
                return
            }
        }.resume() // **ALWAYS** make sure to resume. Otherwise you get bugs that are hard to track down and you're very confused for long time.
    }
    
    
    private func addImageData(to searchResult: Result, imageData: Data) {
        guard let index = searchResults.firstIndex(of: searchResult) else { return }
        
        searchResults[index].imageData = imageData
    }
    
    
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
            
            self.addImageData(to: searchResult, imageData: data)
            completion(nil)
        }.resume()
    }
    
}
