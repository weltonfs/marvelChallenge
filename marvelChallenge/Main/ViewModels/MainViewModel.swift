import Foundation

// MARK: - MainViewModelProtocol

protocol MainViewModelProtocol {
    var showLoading: (() -> Void)? { get set}
    var showMainView: (([Character]) -> Void)? { get set}
    var showErrorView: ((StateView) -> Void)? { get set}
    
    func getCharacters()
    func filter(characters: [Character], with text: String) -> [Character]
}

// MARK: - Class MainViewModel

class MainViewModel: MainViewModelProtocol {
    
    var showLoading: (() -> Void)?
    var showMainView: (([Character]) -> Void)?
    var showErrorView: ((StateView) -> Void)?
    
    func getCharacters() {
        showLoading?()
        
        NetworkManager().fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.showMainView?(characters)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self?.showErrorView?(.error)
            }
        }
    }
    
    func filter(characters: [Character], with text: String) -> [Character] {
        return characters.filter {
            if let name = $0.name {
                return name.lowercased().contains(text.lowercased())
            }
            return false
        }
    }
}
