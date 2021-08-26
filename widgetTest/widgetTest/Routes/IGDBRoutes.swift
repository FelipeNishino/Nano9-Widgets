//
//  IGDBRoutes.swift
//  IGDB API PoC
//
//  Created by Rogerio Lucon on 25/08/21.
//

import Foundation

struct IGDBRoutes {
    
    struct Login: Postable {
        var route = "https://id.twitch.tv/oauth2/token"
        var parameters: Parameter?
        var body: String = ""
    }
    
    struct Game: Postable {
        var route = "https://api.igdb.com/v4/games"
        var parameters: Parameter?
        var body: String = "fields id, name;"
    }
    
    struct Artwork: Postable {
        var route = "https://api.igdb.com/v4/artworks"
        var parameters: Parameter?
        var body: String = "fields height, game, image_id, width;"
    }
}
