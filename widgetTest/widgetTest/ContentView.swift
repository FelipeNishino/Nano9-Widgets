//
//  ContentView.swift
//  widgetTest
//
//  Created by Felipe Nishino on 24/08/21.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
//        WidgetTest()
        
        ImageTest()
    }
    
}

struct WidgetTest: View {
    @State var results = [GameResponse]()
    
    var body: some View {
        List(results, id: \.id) { item in
            Text(item.name)
                .onTapGesture {
                    print(item.id, item.name)
                }
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        NetworkManager.shared.getGameData { data in
            self.results = data ?? [GameResponse.error]
            return
        }
    }
    
}

struct ImageTest: View {
    
    @State var image = UIImage()
    
    var body: some View {
        Image(uiImage: image)
            .onAppear{loadImage()}
    }
    
    func loadImage(){
        HTTPRequest().fetchImageByGame(name: "The Kings Crusade", completion: { result in
            switch result {
            case.success(let image):
                self.image = image
            case .failure(let error):
                print(error)
                if let img = UIImage(named: "imageNotFound") {
                    self.image = img
                }
                else {
                    self.image = UIImage()
                }
            }
        })
    }
}
