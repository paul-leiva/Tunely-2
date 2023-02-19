//
//  Album.swift
//  lab-tunley
//
//  Created by Paul Leiva on 2/19/23.
//

import Foundation

struct Album: Decodable {
    let artworkUrl100: URL
}

struct AlbumSearchResponse: Decodable {
    let results: [Album]
}
