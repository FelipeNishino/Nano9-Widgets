//
//  NetworkManager.swift
//  widgetTest
//
//  Created by Felipe Nishino on 27/08/21.
//

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
    
    func getGameData(completion: @escaping ([GameResponse]?) -> Void) {
        let gameRequest = HTTPRequest()
        let route = IGDBRoutes.Game()
        
        print(buildIds())
        
        gameRequest.request(route.filterBy(field: "id", value: buildIds()), genericType: [GameResponse].self) { result, response in
            switch result {
            case .success(let res):
                print(res)
                return completion(res)
            case .failure(let err):
                print("response error:")
                print(err)
                return completion([GameResponse(id: -1, name: err.localizedDescription)])
            }
        }
    }
}
