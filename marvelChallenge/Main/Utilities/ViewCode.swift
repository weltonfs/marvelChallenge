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
