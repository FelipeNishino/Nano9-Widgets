//
//  ContentView.swift
//  widgetTest
//
//  Created by Felipe Nishino on 24/08/21.
//

import SwiftUI

struct ContentView: View {
    @State var results = [GameResponse]()
    
    var body: some View {
        List(results, id: \.id) { item in
            Text(item.name)
                .onTapGesture {
                    print(item.id, item.name)
                }
//            BootlegAsyncImage(withURL: getImageHash(item))
        }.onAppear(perform: loadData)
    }
    
    func getImageHash(_ game: GameResponse) -> String {
        var url = ""
        HTTPRequest().request(IGDBRoutes.Artwork(), genericType: [ArtworkResponse].self) { result, response in
            switch result {
            case .success(let res):
                print(res)
                url = res.first!.getImageURL()
            case .failure(let err):
                print(err)
                break
            }
        }
        return url
    }
    
    func loadData() {
        NetworkManager.shared.getGameData { data in
            self.results = data ?? [GameResponse.error]
            return
        }
    }
}
