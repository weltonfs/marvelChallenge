import UIKit
import Foundation

class CharacterTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    static let identifier = "CharacterTableViewCell"
    weak var delegate: MainViewDelegate?
    
    // MARK: - Private Properties
    
    private var character: Character?
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "* No name"
        return label
    }()
    
    private lazy var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "noimage.png")
        return imageView
    }()
    
    private lazy var favorite: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "star.square.fill")
        imageView.tintColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setup(character: Character) {
        self.character = character
        name.text = character.name
        thumbnail.downloadThumbnail(thumbnail: character.thumbnail)
        setFavoriteImage(characterId: character.id)
    }
    
    func setFavoriteImage(characterId: Int?) {
        if let id = characterId {
            let isFavorite = UserDefaultsManager.shared.isFavorite(id: id)
            favorite.isHidden = !isFavorite
        }
    }
}

// MARK: - Setup ViewCode

extension CharacterTableViewCell: ViewCode {
    func addSubviews() {
        addSubview(cellView)
        cellView.addSubview(thumbnail)
        cellView.addSubview(favorite)
        cellView.addSubview(name)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            thumbnail.heightAnchor.constraint(equalToConstant: 112),
            thumbnail.widthAnchor.constraint(equalToConstant: 112),
            thumbnail.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            thumbnail.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 8),
            
            favorite.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16),
            favorite.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            
            name.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 8),
            name.leadingAnchor.constraint(equalTo: thumbnail.trailingAnchor, constant: 8),
            name.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -8),
        ])
    }
    
    func setupStyle() {
        backgroundColor = .white
        cellView.backgroundColor = .systemGray6
        
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor.lightGray.cgColor
        cellView.layer.cornerRadius = 10
        cellView.layer.masksToBounds = true
        
        thumbnail.layer.borderWidth = 1
        thumbnail.layer.borderColor = UIColor.lightGray.cgColor
        thumbnail.layer.cornerRadius = 5
        thumbnail.layer.masksToBounds = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        self.addGestureRecognizer(recognizer)
    }
    
    @objc
    func didTapCell() {
        if let character = self.character {
            delegate?.didSelectCell(item: character)
        }
    }
}
