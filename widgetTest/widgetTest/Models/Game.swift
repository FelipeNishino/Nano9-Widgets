//
//  Game.swift
//  widgetTest
//
//  Created by Rogerio Lucon on 30/08/21.
//

import SwiftUI
import Foundation

struct Game: Hashable {
    
    static let error = Game(id: 0, name: "error")
    
    let id: Int
    let name: String
    let icon: UIImage?
    let image: UIImage?
    
    init(id: Int, name: String, icon: UIImage? = UIImage(), image: UIImage? = UIImage()) {
        self.id = id
        self.name = name
        self.icon = icon
        self.image = image
    }
    
    init(gameResponse game: GameResponse) {
        self.id = game.id
        self.name = game.name
        self.icon = nil
        self.image = UIImage()
    }
    
    func setImage(image: UIImage) -> Game {
        return Game(id: id, name: name, icon: icon, image: image)
    }
    
    func setImage(image: UIImage, icon: UIImage) -> Game {
        return Game(id: id, name: name, icon: icon, image: image)
    }
    
    func setIcon(icon: UIImage) -> Game {
        return Game(id: id, name: name, icon: icon, image: image)
    }
    
}
