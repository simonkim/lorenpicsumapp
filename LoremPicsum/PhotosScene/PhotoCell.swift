//
//  PhotoCell.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

// PhotoCell.swift
import UIKit
import Combine

class PhotoCell: UICollectionViewCell {
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private var cancellables: Set<AnyCancellable> = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }

    private func configureUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with photo: Photo, errorSubject: PassthroughSubject<PhotoError, Never>) {
        guard let imageURL = URL(string: photo.downloadUrl) else {
            imageView.image = UIImage(named: "placeholderImage")
            return
        }

        Task {
            do {
                try await imageView.loadImage(from: imageURL, placeholder: UIImage(named: "placeholderImage"))
            } catch {
                errorSubject.send(.imageLoadingFailed)
            }
        }
    }
}
