//
//  CharacterModel.swift
//  MarvelChallenge
//
//  Created by MacBook Pro on 05/11/24.
//

import Foundation

typealias Characters = [Character]

// MARK: - Character

struct Character: Codable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "character_name"
    }
}
