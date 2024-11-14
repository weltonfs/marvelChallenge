import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard
    private let favoriteCharacterKey = "favoriteCharacterKey"
    
    private init() {}
    
    var favorites: [Int] {
        get {
            return userDefaults.array(forKey: favoriteCharacterKey) as? [Int] ?? []
        }
        set {
            userDefaults.set(newValue, forKey: favoriteCharacterKey)
        }
    }
        
    func isFavorite(id: Int) -> Bool {
        return favorites.contains(id)
    }
    
    func addFavorite(id: Int) {
        favorites.append(id)
    }
    
    func removeFavorite(id: Int) {
        if let index = favorites.firstIndex(of: id) {
            favorites.remove(at: index)
        }
    }
}
