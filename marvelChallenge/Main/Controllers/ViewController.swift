import UIKit

enum StateView: Error {
    case loading
    case loaded
    case error
}

protocol ViewDelegate: AnyObject {
    func didTapButton()
    func didTapErrorButton()
}

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var mainScreen: MainView = {
        let view = MainView()
        view.delegate = self
        return view
    }()
    
    private var characters: [Character]?
    
    // MARK: - Initiators
    
    override func loadView() {
        super.loadView()
        
        self.view = mainScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Marvel Challenge"
        loadingMainScreen()
        getCharacters()
    }
}

// MARK: - Private Methods

private extension ViewController {

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

extension ViewController: ViewDelegate {
    func didTapButton() {
        debugPrint("Delegate ok")
    }
    
    func didTapErrorButton() {
        debugPrint("Error Delegate ok")
        
        loadingMainScreen()
        getCharacters()
    }
}
