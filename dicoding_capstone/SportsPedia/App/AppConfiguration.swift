//
//  AppConfiguration.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Foundation

enum AppConfiguration {
    private static let apiBaseURLKey = "API_BASE_URL"

    static var apiBaseURL: URL {
        guard let value = Bundle.main.object(forInfoDictionaryKey: apiBaseURLKey) as? String,
              let url = URL(string: value) else {
            preconditionFailure("API_BASE_URL belum dikonfigurasi pada Build Settings.")
        }
        return url
    }
}
