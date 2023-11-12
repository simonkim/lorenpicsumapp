//
//  ErrorView.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import UIKit

class ErrorView: UIView {

    private var titleLabel: UILabel!
    private var closeButton: UIButton!
    private var closeAction: (() -> Void)?

    init(frame: CGRect, message: String, closeAction: (() -> Void)? = nil) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red.withAlphaComponent(0.8)

        titleLabel = UILabel()
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = message
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)

        closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        addSubview(closeButton)

        self.closeAction = closeAction

        setupConstraints()
        animateAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
        ])
    }

    private func animateAppearance() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.frame.origin.y = 0
        }, completion: { _ in
            self.perform(#selector(self.dismiss), with: nil, afterDelay: 2.0)
        })
    }

    @objc private func closeButtonTapped() {
        dismiss()
        closeAction?()
    }

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.frame.origin.y = -self.frame.size.height
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}
