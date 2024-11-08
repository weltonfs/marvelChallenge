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
    
    // MARK: - Private Properties
    
    private var characters: [Character]?
    
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
        
        loadingMainScreen(with: .loading)
        getCharacters()
    }
}

// MARK: - Private Methods

private extension MainViewController {
    
    func loadingMainScreen(with state: StateView = .loading) {
        DispatchQueue.main.async { [self] in
            mainScreen.setup(state: state, characters: self.characters ?? [])
        }
    }
    
    func getCharacters() {
        NetworkManager().fetchCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                self?.loadingMainScreen(with: .loaded)
            case .failure(let error):
                print("fetchCharacters - Error : \(error)")
                self?.loadingMainScreen(with: .error)
            }
        }
    }
}

// MARK: - ViewDelegate

extension MainViewController: MainViewDelegate {
    func didSelectCell(item: Character) {
        debugPrint(item)
        
//        TODO: call detail screen
    }
    
    func didTapErrorButton() {
        loadingMainScreen()
        getCharacters()
    }
}

