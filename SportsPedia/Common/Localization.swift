//
//  Localization.swift
//  SportsPedia
//

import Foundation

/// Shared localization entry point for the Common module.
/// Feature modules use this type when a generated string accessor is not available.
enum CommonLocalization {
    static func string(_ key: String, table: String = "Localizable") -> String {
        Bundle.main.localizedString(forKey: key, value: key, table: table)
    }

    static func formatted(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: string(key), locale: .current, arguments: arguments)
    }
}
