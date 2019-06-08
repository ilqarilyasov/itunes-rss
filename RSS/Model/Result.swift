//
//  Result.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import Foundation

struct Result: Decodable, Equatable {
    let artistName: String
    let name: String
    let kind: Kind
    let artworkUrl100: String
    var imageData: Data? = nil
    
    enum ResultCodingKeys: String, CodingKey {
        case artistName, name, kind, artworkUrl100
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultCodingKeys.self)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.name = try container.decode(String.self, forKey: .name)
        let kind = try container.decode(String.self, forKey: .kind)
        self.kind = Kind(rawValue: kind) ?? .album
        self.artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
    }
}
