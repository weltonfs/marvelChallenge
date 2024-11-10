import UIKit

class DetailView: UIView {
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "noimage.png")
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.text = "* No description"
        return textView
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setup(character: Character) {
        DispatchQueue.main.async { [self] in
            
            if character.name == "" {
                label.text = "* No name"
            } else {
                label.text = character.name
            }
            
            if character.description == "" {
                textView.text = "* No description"
            } else {
                textView.text = character.description
            }
            
            image.downloadThumbnail(thumbnail: character.thumbnail)
        }
    }
}

// MARK: - ViewCode

extension DetailView: ViewCode {
    func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubview(image)
        container.addSubview(label)
        container.addSubview(textView)
    }
    
    func setupConstraints() {
        let size = UIScreen.main.bounds
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            image.heightAnchor.constraint(equalToConstant: size.width-16),
            image.widthAnchor.constraint(equalToConstant: size.width-16),
            image.topAnchor.constraint(equalTo: container.topAnchor),
            image.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            image.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            
            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),

            textView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
        ])
    }
    
    func setupStyle() {        
        self.backgroundColor = .white
        label.backgroundColor = .systemGray6

        image.layer.setBorder()
        label.layer.setBorder()
    }
}
