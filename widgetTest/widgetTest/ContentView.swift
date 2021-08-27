//
//  ContentView.swift
//  widgetTest
//
//  Created by Felipe Nishino on 24/08/21.
//

import SwiftUI
import Foundation
import Combine

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}

struct BootlegAsyncImage: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:100, height:100)
                .onReceive(imageLoader.didChange) { data in
                self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

struct ContentView: View {
    @State var results = [GameResponse]()
    
    var body: some View {
        List(results, id: \.id) { item in
            Text(item.name)
                .onTapGesture {
                    //                    save(item)
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
        let gameRequest = HTTPRequest()
        var route = IGDBRoutes.Game()
        route.parameters = ["fields" : "id, name;","limit" : "5"]
        gameRequest.request(route, genericType: [GameResponse].self) { result, response in
            switch result {
            case .success(let res):
                self.results = res
                break
            case .failure(let err):
                print("response error:")
                print(err)
            }
        }
    }
}
