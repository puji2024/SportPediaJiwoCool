//
//  Team.swift
//  SportsPedia
//
//  Created by Puji Wahono on 01/09/26.
//

import Foundation

struct Team: Identifiable, Codable, Hashable, Sendable {
    let id: String
    let name: String
    let badgeURL: URL?
    let formedYear: String?
    let stadium: String?
    let description: String?
    let country: String?
}
