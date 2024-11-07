import UIKit

class MainView: UIView {
    
    // MARK: - Public Properties
    
    weak var delegate: ViewDelegate?
    
    // MARK: - Private Properties
    
    private lazy var activityIndicator: UIView = {
        let ai = LoadingView()
        return ai
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: CharacterTableViewCell.identifier)
        tableView.allowsSelection = false
        return tableView
    }()
    
    private lazy var errorView: UIView = {
        let view = ErrorView()
        view.delegate = self
        return view
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
    
    func setup(state: StateView, characters: [Character] = []) {
        switch state {
        case .loading:
            activityIndicator.isHidden = false
            tableView.isHidden = true
            errorView.isHidden = true
        case .loaded:
            activityIndicator.isHidden = true
            if characters.isEmpty {
                tableView.isHidden = true
            } else {
                tableView.isHidden = false
            }
        case .error:
            activityIndicator.isHidden = true
            tableView.isHidden = true
            errorView.isHidden = false
        }
    }
        
    @objc
    internal func didTapButton() {
        delegate?.didTapButton()
    }
}

// MARK: - UITableViewDelegate

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint(tableView.indexPathForSelectedRow ?? 0)
    }
}

extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
}

// MARK: - ViewCode

extension MainView: ViewCode {
    func addSubviews() {
        addSubview(activityIndicator)
        addSubview(label)
        addSubview(button)
        addSubview(tableView)
        addSubview(errorView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: self.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            errorView.topAnchor.constraint(equalTo: self.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupStyle() {
        backgroundColor = .white
        activityIndicator.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    }
}

extension MainView: ViewDelegate {
    func didTapErrorButton() {
        self.delegate?.didTapErrorButton()
    }
}
