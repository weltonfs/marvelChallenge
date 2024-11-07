import Foundation

typealias Characters = [Character]

struct CharactersData: Codable {
    var data: Results?
}
struct Results: Codable {
    var results: Characters?
}

// MARK: - Character

struct Character: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
}

struct Thumbnail: Codable {
    var path: String?
    var imageExtension: String?
    
    public enum ThumbnailKeys: String, CodingKey{
        case path = "path"
        case imageExtension = "extension"
    }
}
