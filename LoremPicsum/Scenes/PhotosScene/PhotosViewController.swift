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
    private var viewModel: PhotoViewModel
    private var cancellables: Set<AnyCancellable> = []
    private static let cellItemSize = CGSize(width: 100, height: 100)
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(collectionViewLayout: {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = Self.cellItemSize
            return layout
        }())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("deinit")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
        fetchPhotos()
        displayShort(.info, message: "Welcome")
        self.title = "Lorem Picsum Photos"
    }
    
    private func configureCollectionView() {
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")

        dataSource = UICollectionViewDiffableDataSource<Int, Photo>(collectionView: collectionView) { collectionView, indexPath, photo in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            cell.configure(with: photo) { [weak viewModel = self.viewModel] photo, completion in
                viewModel?.getImage(for: photo, targetSize: Self.cellItemSize, completion: completion)
            }
            return cell
        }
    }

    private func bindViewModel() {
        viewModel.photosPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.applySnapshot(photos)
            }
            .store(in: &cancellables)

        viewModel.photoErrorSubject
            .receive(on: DispatchQueue.main)
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

        displayShort(.error, message: errorMessage)
    }

    private func displayShort(_ type: NoticeType, message: String) {
        ShortNotice.display(type, message: message, in: self.collectionView)
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == viewModel.photos.count - 1 {
            currentPage += 1
            fetchPhotos()
        }
    }
}

extension PhotoViewController {
     override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         viewModel.didSelectPhoto(at: indexPath.item)
     }
 }
