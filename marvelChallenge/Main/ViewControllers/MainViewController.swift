import UIKit

enum StateView: Error {
    case loading
    case loaded
    case error
}

// MARK: - MainViewDelegate

protocol MainViewDelegate: AnyObject {
    func didSelectCell(item: Character)
    func didTapErrorButton()
}

// MARK: - Class MainViewController

class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let searchController = UISearchController()
    
    private var viewModel: MainViewModelProtocol
    private var characters: [Character]?
    private var filteredCharacters: [Character] = []
    
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
        
        setupNavigationBar()
        setupBind()
        viewModel.getCharacters()
    }
    
    init() {
        viewModel = MainViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    func setupNavigationBar() {
        navigationItem.title = "Marvel Challenge"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    func setupBind() {
        viewModel.showLoading = { [weak self] in
            self?.loadMainScreen(state: .loading)
        }
        
        viewModel.showMainView = { [weak self] characters in
            self?.characters = characters
            self?.loadMainScreen(state: .loaded, characters: characters)
        }
        
        viewModel.showErrorView = { [weak self] state in
            self?.loadMainScreen(state: .error)
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
                self.loadMainScreen(state: StateView.loaded, characters: characters)
                return
            }
            
            filteredCharacters = viewModel.filter(characters: characters, with: text)
            
            self.loadMainScreen(state: StateView.loaded, characters: filteredCharacters)
        }
    }
}

// MARK: - MainView Delegate

extension MainViewController: MainViewDelegate {
    
    func didSelectCell(item: Character) {
        let detailViewController = DetailViewController()
        detailViewController.setup(character: item)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func didTapErrorButton() {
        viewModel.getCharacters()
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
