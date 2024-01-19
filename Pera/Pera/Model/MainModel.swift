//
//  MainModel.swift
//  Pera
//
//  Created by Onur on 19.01.2024.
//

import Foundation

struct MainModel: Codable {
    var id: Int
    var name: String?
    var htmlUrl: String?
    var description: String?
    var isFavoriteKey: String {
        return "FavoriteStatus_\(id)"
    }
}
