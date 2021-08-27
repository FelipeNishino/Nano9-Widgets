//
//  GameResponse.swift
//  IGDB API PoC
//
//  Created by Rogerio Lucon on 25/08/21.
//

import Foundation

struct GameResponse: Codable, Hashable {
    let id: Int
    let name: String
    
    static let error = GameResponse(id: 0, name: "error")
}
