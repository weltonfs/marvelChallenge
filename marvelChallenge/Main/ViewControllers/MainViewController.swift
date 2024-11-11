import UIKit

enum StateView: Error {
    case loading
    case loaded
    case error
}

protocol MainViewDelegate: AnyObject {
    func didSelectCell(item: Character)
    func didTapErrorButton()
}

class MainViewController: UIViewController {
    
    let searchController = UISearchController()
    
    // MARK: - Private Properties
    
    private var characters: [Character]?
    private var filteredCharacters: [Character] = []
    private var userDefaults = UserDefaults.standard
        
    private lazy var mainScreen: MainView = {
        let view = MainView()
        view.delegate = self
        return view
    }()
    
    // MARK: - Initiators
    
    override func loadView() {
        super.loadView()
        
        self.view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Marvel Challenge"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        fetchCharacters()
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    func fetchCharacters() {
        loadMainScreen(state: .loading)
        
        NetworkManager().fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                self?.loadMainScreen(state: .loaded, characters: characters)
            case .failure(let error):
                print("fetchCharacters - Error : \(error)")
                self?.loadMainScreen(state: .error)
            }
        }
    }
    
    func loadMainScreen(state: StateView = .loading, characters: [Character] = []) {
        DispatchQueue.main.async { [self] in
            mainScreen.setup(state: state, characters: characters)
        }
    }
    
    func filterCharacter(with text: String) {
        filteredCharacters.removeAll()
        if let characters = self.characters {
            if text.isEmpty {
                filteredCharacters = characters
                self.loadMainScreen(state: .loaded, characters: characters)
                return
            }
            
            filteredCharacters = characters.filter {
                if let name = $0.name {
                    return name.lowercased().contains(text.lowercased())
                }
                return false
            }
            
            self.loadMainScreen(state: .loaded, characters: filteredCharacters)
        }
    }
}

// MARK: - ViewDelegate

extension MainViewController: MainViewDelegate {
    
    func didSelectCell(item: Character) {
        let detailViewController = DetailViewController()
        detailViewController.setup(character: item)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didTapErrorButton() {
        fetchCharacters()
    }
}

// MARK: - UISearchResultsUpdating

extension MainViewController: UISearchResultsUpdating {
        
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        filterCharacter(with: text)
    }
}
