
import UIKit

class ErrorView: UIView {
    
    weak var delegate: MainViewDelegate?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ops!"
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapErrorButton), for: .touchUpInside)
        button.setTitle("Tentar novamente", for: .normal)
        return button
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didTapErrorButton() {
        delegate?.didTapErrorButton()
    }
}

extension ErrorView: ViewCode {
    func addSubviews() {
        addSubview(label)
        addSubview(button)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            button.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func setupStyle() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }
}
