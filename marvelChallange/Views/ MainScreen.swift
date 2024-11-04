//
//   MainScreen.swift
//  marvelChallenge
//
//  Created by MacBook Pro on 04/11/24.
//

import UIKit

protocol ViewDelegate: AnyObject {
    func didTapButton()
}

class MainScreen: UIView {
    
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
    
    weak var delegate: ViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(labelText: String, buttonTitle: String) {
        label.text = labelText
        button.setTitle(buttonTitle, for: .normal)
    }
    
    @objc
    private func didTapButton() {
        delegate?.didTapButton()
    }
}

extension MainScreen: ViewCode {
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
        backgroundColor = .white
    }
}
