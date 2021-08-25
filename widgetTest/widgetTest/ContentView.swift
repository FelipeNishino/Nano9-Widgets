//
//  ContentView.swift
//  widgetTest
//
//  Created by Felipe Nishino on 24/08/21.
//

import SwiftUI

struct ContentView: View {
    @State var results = [FOAASMessage]()
    
    @AppStorage("FOAAS", store: UserDefaults(suiteName: "group.com.felipenishino.widgetTest"))
    var FOAASData: Data = Data()
    
    var body: some View {
        List(results, id: \.id) { item in
            MessageView(message: item)
                .onTapGesture {
                    save(item)
                }
        }.onAppear(perform: loadData)
    }
    
    func save(_ item: FOAASMessage) {
        guard let FOAASData = try? JSONEncoder().encode(item) else {
            print("Error encoding FOAAS into json")
            return
        }
        self.FOAASData = FOAASData
        print("Saved message: \(item)")
    }
    
    func loadData() {
        (0...4).forEach { _ in
            let from = ["some%20dipshit", "some%20dumbfuck", "some%20fucker"].randomElement()!
            let endpoints = ["bye/\(from)", "dumbledore/\(from)", "fewer/anon/\(from)", "flying/\(from)", "king/anon/\(from)"]
            guard let selectedEndpoint = endpoints.randomElement() else { return }
            guard let url = URL(string: "https://foaas.com/\(selectedEndpoint)") else {
                print("Your API end point is Invalid, url: https://foaas.com/\(selectedEndpoint)")
                return
            }
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            URLSession.shared.dataTask(with: request) { data, res, error in
                if error != nil || data == nil {
                    print("Client error!")
                    return
                }
                
                guard let res = res as? HTTPURLResponse,
                      (200...299).contains(res.statusCode) else {
                    self.handleServerError(res!)
                    return
                }
                
                guard let mime = res.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    print(json)
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
                do {
                    let response = try FOAASMessage(from: data)
                    self.results.append(response)
                }
                catch {
                    print("Error on message decoding")
                }
                
                return
            }.resume()
        }
        
    }
    
    func handleServerError(_ res: URLResponse) {
        print("Azedou")
    }
}
