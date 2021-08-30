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
        var games = [Game]()
        games.append(.init(id: 1, name: "Genshin impact", icon: UIImage(named: "steam_icon"), image: UIImage(named: "genshin-impact")))
        games.append(.init(id: 1, name: "Gran Turismo Sport", icon: UIImage(named: "steam_icon"), image: UIImage(named: "Gran turismo")))
        games.append(.init(id: 1, name: "GTA 5", icon: UIImage(named: "steam_icon"), image: UIImage(named: "GTA-5")))
        games.append(.init(id: 1, name: "Genshin impact", icon: UIImage(named: "steam_icon"), image: UIImage(named: "genshin-impact")))
        games.append(.init(id: 1, name: "Gran Turismo Sport", icon: UIImage(named: "steam_icon"), image: UIImage(named: "Gran turismo")))
        games.append(.init(id: 1, name: "GTA 5", icon: UIImage(named: "steam_icon"), image: UIImage(named: "GTA-5")))
        completion(games)
//        let gameRequest = HTTPRequest()
//        let route = IGDBRoutes.Game()
//
//        print(buildIds())
//
//        gameRequest.request(route.filterBy(field: "id", value: buildIds()), genericType: [GameResponse].self) { result, response in
//            switch result {
//            case .success(let res):
//                print(res)
//                let games = res.map { Game(gameResponse: $0) }
//                completion(games)
//            case .failure(let err):
//                print("response error:")
//                print(err)
//                return completion([Game(id: -1, name: err.localizedDescription)])
//            }
//        }
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
