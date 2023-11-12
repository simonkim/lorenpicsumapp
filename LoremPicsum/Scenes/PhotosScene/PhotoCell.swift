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

    private let preferredImageScale: CGFloat = { UIScreen.main.scale }()
    private var placeholderImage: UIImage? = {
        UIImage(systemName: "icloud")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
    }()
    
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

    var photoId: Photo.ID?
    func configure(with photo: Photo, getImage: @escaping (Photo, @escaping (UIImage?) -> Void) -> Void) {

        // Reset the image to a placeholder
        photoId = photo.id
        imageView.image = placeholderImage
        imageView.contentMode = .scaleAspectFit

        // Fetch the image using the provided function
        getImage(photo) { [weak self] image in
            // Ensure that the cell is still configured for the correct photo
            guard self?.photoId == photo.id else {
                return
            }
            
            self?.imageView.image = image
            self?.imageView.contentMode = .scaleAspectFill

        }
    }
}
