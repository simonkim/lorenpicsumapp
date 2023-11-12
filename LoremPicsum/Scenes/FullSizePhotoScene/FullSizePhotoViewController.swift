//
//  FullSizePhotoViewController.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import UIKit


class FullSizePhotoViewController: UIViewController {
    private let viewModel: FullSizePhotoViewModel
    
    init(viewModel: FullSizePhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let overlayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(overlayLabel)

        // Set up constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            overlayLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            overlayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

        // Add a tap gesture recognizer to dismiss the view controller
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
        view.addGestureRecognizer(tapGesture)
        
        Task {
            do {
                try await imageView.loadImage(from: viewModel.imageUrl)
            } catch {
                ShortNotice.display(.error, message: "Failed to load image", in: view)
            }
        }
        overlayLabel.attributedText = viewModel.attribugedCaption
    }

    @objc private func dismissViewController() {
        viewModel.send(.dismiss)
    }
}
