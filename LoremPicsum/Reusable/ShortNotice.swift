//
//  ShortNotice.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import UIKit

extension ShortNotice {
    /// Displays a ShortNotice with the specified type, message, and optional timeout and close action.
    ///
    /// - Parameters:
    ///   - type: The type of the notice (error or info).
    ///   - message: The message to be displayed in the notice.
    ///   - view: The view in which the notice will be displayed.
    ///   - timeout: The time duration for which the notice will be visible. Defaults to 2 seconds.
    ///   - closeAction: An optional closure to be executed when the notice is tapped. Defaults to nil.
    static func display(_ type: NoticeType,
                        message: String,
                        in view: UIView,
                        timeout: TimeInterval = 2,
                        closeAction: (() -> Void)? = nil) {
        let frame = CGRect(x: 0, y: -50, width: view.bounds.width, height: 50)
        let notice = ShortNotice(type: type, message: message, timeout: timeout, closeAction: closeAction)
        notice.frame = frame

        // Add the notice to the provided view
        view.addSubview(notice)
    }
}

enum NoticeType {
    case error
    case info

    var backgroundColor: UIColor {
        switch self {
        case .error:
            return .systemRed
        case .info:
            return .systemGreen
        }
    }
}

class ShortNotice: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var closeAction: (() -> Void)?

    init(type: NoticeType, message: String, timeout: TimeInterval, closeAction: (() -> Void)? = nil) {
        super.init(frame: .zero)

        backgroundColor = type.backgroundColor
        layer.cornerRadius = 8

        addSubview(label)
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        label.text = message
        self.closeAction = closeAction

        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [weak self] in
            self?.dismiss()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.closeAction?()
            self.removeFromSuperview()
        }
    }
}
