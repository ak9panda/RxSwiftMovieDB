//
//  Settings.swift
//  GithubRepo
//
//  Created by admin on 15/11/2021.
//

import Foundation

struct AppSettings: Codable {
    
    let apiKey: String
    
    private enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}

struct Settings {
    
    // get api key from property list (.plist)
    static var apiKey: String {
        guard let url = Bundle.main.url(forResource: "AppSetting", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let appSetting = try? PropertyListDecoder().decode(AppSettings.self, from: data)
        else {
            preconditionFailure("AppSettings was not found.")
        }
        
        guard !appSetting.apiKey.isEmpty else {
            preconditionFailure("Api key is missing from AppSettings")
        }
        
        return appSetting.apiKey
    }
}
