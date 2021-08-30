//
//  NetworkManager.swift
//  widgetTest
//
//  Created by Felipe Nishino on 27/08/21.
//
import SwiftUI
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    let ids = ["33284","104748","146815","85450","89616"]
    
    private func buildIds() -> String {
        var str = "("
        ids.forEach { id in
            str += "\(id),"
        }
        return str.dropLast() + ")"
    }
    
    func getGameData(completion: @escaping ([Game]?) -> Void) {
        let gameRequest = HTTPRequest()
        let route = IGDBRoutes.Game()
        
        print(buildIds())
        
        gameRequest.request(route.filterBy(field: "id", value: buildIds()), genericType: [GameResponse].self) { result, response in
            switch result {
            case .success(let res):
                print(res)
                let games = res.map { Game(gameResponse: $0) }
                self.getImage(games: games) { result in
                    completion(result)
                }
            case .failure(let err):
                print("response error:")
                print(err)
                return completion([Game(id: -1, name: err.localizedDescription)])
            }
        }
    }
    
    func getImage(games: [Game], completion: ([Game]?) -> Void) {
        var results: [Game] = []
        for game in games {
            HTTPRequest().fetchImageByGame(name: game.name) { result in
                switch result {
                case .success(let image):
                    results.append(game.setImage(image: image))
                case .failure(_):
                    results.append(game.setImage(image: UIImage()))
                }
            }
        }
        completion(results)
    }
}
