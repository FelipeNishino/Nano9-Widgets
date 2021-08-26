//
//  LoginResponse.swift
//  IGDB API PoC
//
//  Created by Rogerio Lucon on 25/08/21.
//

import Foundation

struct LoginReponse: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
