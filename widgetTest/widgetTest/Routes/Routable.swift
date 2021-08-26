//
//  Routable.swift
//  IGDB API PoC
//
//  Created by Rogerio Lucon on 25/08/21.
//

import Foundation

protocol Routable {
    typealias Parameter = [String: String]
    
    var route: String { get }
    var method: String { get }
    var body: String { get set }
    var parameters: Parameter? { get set }
}

extension Routable {
    func body(string: String) -> RequestConvertable {
        return RequestConvertable(route: self.route, method: self.method, body: string, parameters: parameters)
    }
    
    func filterBy(field: String, value: String) -> RequestConvertable {
        let newBody = body + String(format:"where %1$@ = %2$@;", field, value)
        return self.body(string: newBody)
    }
}

protocol Postable: Routable {}

extension Postable {
    var method: String { "POST" }
    
    func post(parameters: Parameter) -> RequestConvertable {
        return RequestConvertable(route: self.route, method: self.method,body: self.body, parameters: parameters)
    }
}

struct RequestConvertable: Routable {
    var route: String
    var method: String
    var body: String
    var parameters: Parameter?
}
