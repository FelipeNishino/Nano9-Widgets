//
//  Model.swift
//  widgetTest
//
//  Created by Felipe Nishino on 24/08/21.
//

import Foundation

enum FOAASError : Error {
    case jsonDecodeError
    case jsonEncodeError
}

struct FOAASMessage : Codable, Identifiable {
    var message: String
    var subtitle: String
    var id: String { message }
    
    init(message: String, subtitle: String) {
        self.message = message
        self.subtitle = subtitle
    }
    
    init(from data: Data?) throws {
        guard let message = try? JSONDecoder().decode(FOAASMessage.self, from: data!) else {
            print("Error on json decoding")
            throw FOAASError.jsonDecodeError
        }
        self.message = message.message
        self.subtitle = message.subtitle
        return
    }
    
    func encode(to encoder: Encoder) throws -> Data {
        do {
            return try JSONEncoder().encode(self)
        }
        catch {
            throw FOAASError.jsonEncodeError
        }
    }
    
    static func placeholder() -> FOAASMessage {
        return FOAASMessage(message: "message goes here!", subtitle: "- subtitle")
    }
}
