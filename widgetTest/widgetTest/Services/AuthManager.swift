//
//  AuthManager.swift
//  IGDB API PoC
//
//  Created by Rogerio Lucon on 25/08/21.
//

import Foundation

class AuthManager {
    static var shared = AuthManager()
    
    var clientID: String   { "pquwfooxc9t7drxdtm9tcl7rre8xr4" }
    var clientSecret: String { "s5ejgclapiuyy29a4q9wc0iioojkih" }
    var grantType: String { "client_credentials" }
    
    var autorization: String { "Bearer \(accessToken ?? "")" }
    var accessToken: String?
    
    var startTime: Date?
    var isAuthentication: Bool { startTime == nil ? false : Date().timeIntervalSince(startTime!) >= Double(loginResponse!.expiresIn) }
    
    var loginResponse: LoginReponse? {
        didSet {
            accessToken = loginResponse?.accessToken
            startTime = Date()
        }
    }
    
    func getAuth() -> String {
        "Bearer " + accessToken!
    }

    private init() {}

}
