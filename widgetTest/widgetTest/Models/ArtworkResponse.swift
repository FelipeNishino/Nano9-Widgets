//
//  ArtworkResponse.swift
//  IGDB API PoC
//
//  Created by Rogerio Lucon on 25/08/21.
//

import Foundation
import UIKit

struct ArtworkResponse: Codable {
    let id: Int
    let game: Int
    let imageId: String
    let height: Int
    let width: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, game, height, width
        case imageId = "image_id"
    }
    
    func getImageURL() -> String {
        "https://images.igdb.com/igdb/image/upload/t_screenshot_huge/\(imageId).jpg"
    }
}

