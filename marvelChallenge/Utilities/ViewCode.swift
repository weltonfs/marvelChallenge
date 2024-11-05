//
//  ViewCode.swift
//  marvelChallenge
//
//  Created by MacBook Pro on 04/11/24.
//

protocol ViewCode {
    func addSubviews()
    func setupConstraints()
    func setupStyle()
}

extension ViewCode {
    func setup() {
        addSubviews()
        setupConstraints()
        setupStyle()
    }
}
