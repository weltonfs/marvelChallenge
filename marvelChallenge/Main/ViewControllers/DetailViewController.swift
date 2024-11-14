import UIKit

class DetailViewController: UIViewController {
    
    private var character: Character?
    private var barButton: UIBarButtonItem?
    
    // MARK: - Private Properties
    
    private lazy var detailScreen: DetailView = {
        let view = DetailView()
        
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
            setNavigationTitle(with: character)
            detailScreen.setup(with: character)
        }
        
        setFavoriteButton()
        
    }
    
    // MARK: - Public Methods
    
    func setup(character: Character) {
        self.character = character
    }
    
    // MARK: - @objc funcs
    
    @objc
    internal func favoriteCharacter() {
        setFavorite()
    }
}

// MARK: - Private Methods

private extension DetailViewController {
    
    func setNavigationTitle(with character: Character) {
        navigationItem.title = character.name ?? "Marvel Challenge"
    }
    
    func setFavoriteButton() {
        barButton = UIBarButtonItem(image: getItemImage(),
                                    style: .plain,
                                    target: self,
                                    action: #selector(self.favoriteCharacter))
        navigationItem.rightBarButtonItem = barButton
    }
    
    func getItemImage() -> UIImage? {
        
        guard let id = character?.id else {
            return UIImage(systemName: "star.square")
        }
        let isFavorite = UserDefaultsManager.shared.isFavorite(id: id)
        let image = isFavorite ? "star.square.fill" : "star.square"
        return UIImage(systemName: image)
    }
    
    func setFavorite() {
        guard let id = character?.id else {
            return
        }
        
        let isFavorite = UserDefaultsManager.shared.isFavorite(id: id)
        if isFavorite {
            UserDefaultsManager.shared.removeFavorite(id: id)
        } else {
            UserDefaultsManager.shared.addFavorite(id: id)
        }
        setFavoriteButton()
    }
}
