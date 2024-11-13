import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var character: Character?
    
    private lazy var detailScreen: DetailView = {
        let view = DetailView()
        //        view.delegate = self
        return view
    }()
    
    // MARK: - Initiators
    
    override func loadView() {
        super.loadView()
        
        self.view = detailScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let character = self.character {
            navigationItem.title = character.name
            detailScreen.setup(character: character)
        } else {
            navigationItem.title = "Marvel Challenge"
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.square.fill"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(self.favoriteCharacter))
    }
    
    func setup(character: Character) {
        self.character = character
    }
    
    @objc
    internal func favoriteCharacter() {
        // TODO: add function
        debugPrint("Add favorite caller")
    }
}
