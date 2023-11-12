//
//  PhotosViewController.swift
//  LoremPicsum
//
//  Created by Simon Kim on 11/12/23.
//

import UIKit
import Combine

class PhotoViewController: UICollectionViewController {
    private var dataSource: UICollectionViewDiffableDataSource<Int, Photo>!
    private var currentPage = 1
    private var viewModel = PhotoViewModel()
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
        fetchPhotos()
    }

    private func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")

        dataSource = UICollectionViewDiffableDataSource<Int, Photo>(collectionView: collectionView) { collectionView, indexPath, photo in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            cell.configure(with: photo, errorSubject: self.viewModel.photoErrorSubject)
            return cell
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        return layout
    }

    private func bindViewModel() {
        viewModel.photosPublisher
            .sink { [weak self] photos in
                self?.applySnapshot(photos)
            }
            .store(in: &cancellables)

        viewModel.photoErrorSubject
            .sink { [weak self] error in
                self?.handleError(error)
            }
            .store(in: &cancellables)
    }

    private func applySnapshot(_ photos: [Photo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Photo>()
        snapshot.appendSections([0])
        snapshot.appendItems(photos)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func fetchPhotos() {
        Task {
            await viewModel.fetchPhotos(page: currentPage)
        }
    }

    private func handleError(_ error: PhotoError) {
        var errorMessage = "An error occurred"

        switch error {
        case .imageLoadingFailed:
            errorMessage = "Failed to load image"
        }

        displayError(message: errorMessage)
    }

    private func displayError(message: String) {
        let errorView = ErrorView(frame: CGRect(x: 0, y: -50, width: collectionView.bounds.width, height: 50), message: message) {
            // Optional: Handle close action if needed
        }
        collectionView.addSubview(errorView)
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photos.count - 1 {
            currentPage += 1
            fetchPhotos()
        }
    }
}
