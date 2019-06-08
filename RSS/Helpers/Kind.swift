//
//  Kind.swift
//  RSS
//
//  Created by Ilgar Ilyasov on 6/7/19.
//  Copyright © 2019 IIIyasov. All rights reserved.
//

import Foundation

enum Kind: String, Decodable {
    case album = "album"
    case iosSoftware = "iosSoftware"
    case movie = "movie"
}
