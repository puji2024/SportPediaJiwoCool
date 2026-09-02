//
//  AppConfiguration.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Foundation

enum AppConfiguration {
    private static let apiV2KeyName = "API_V2_KEY"

    static var apiV2Key: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: apiV2KeyName) as? String,
              !value.isEmpty,
              !value.contains("$(") else {
            preconditionFailure("API_V2_KEY belum dikonfigurasi pada Build Settings.")
        }
        return value
    }
}
