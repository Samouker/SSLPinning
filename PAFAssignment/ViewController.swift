//
//  ViewController.swift
//  PAFAssignment
//
//  Created by Rajan on 15/04/24.
//

import UIKit
import Network

// MARK: - PhotoCell

class PhotoCell: UICollectionViewCell {
    // Outlets for UI elements
    @IBOutlet weak var ivThumb: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnRetry: UIButton!
    
    // Configuring cell with photo data
    func configureWith(photo: Photo, completion: ImageCompletionHandler?) {
        // Check if thumbnail URL exists
        if let thumbUrl = photo.urls.thumb {
            // Hide retry button initially
            self.btnRetry.isHidden = true
            
            // Set thumbnail image
            self.ivThumb.setThumbImage(path: thumbUrl) { status in
                // Call completion handler with status
                completion?(status)
                
                // Show retry button if image loading fails
                self.btnRetry.isHidden = status
            }
        }
    }
}

// MARK: - ViewController

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // ViewModel instance
    let photoViewModel = PhotoViewModel()
    
    // Pagination variables
    var currentPage = 1
    let perPage = 30
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        self.title = "PAF Assignment"
        
        // Set collectionView data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Configure collectionView layout
        let ww = self.collectionView.frame.size.width / 3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ww, height: ww)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        
        // Fetch initial photos
        fetchPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Network monitoring
        NetworkMonitor.shared.addObserver(forController: ViewController.self) { status in
            self.showMessage(message: status ? Messages.connactionBack : Messages.noConnection, isError: !status)
            
            // Reload photos
            if status {self.fetchPhotos()}
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop network monitoring
        NetworkMonitor.shared.removeObserver(forController: ViewController.self)
    }

    // Function to handle network status change
    func statusDidChange(status: NWPath.Status) {
        // Handle network status change here
    }

    // Fetch photos from ViewModel
    func fetchPhotos() {
        // Check network connectivity
        if NetworkMonitor.shared.isConnected {
            // Fetch photos from ViewModel
            photoViewModel.fetchPhotos(page: currentPage, perPage: perPage) { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    // Show error message
                    self?.showMessage(message: errorMessage, isError: true)
                } else {
                    // Reload collectionView data on successful fetch
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                    }
                }
            }
        } else {
            // Show no internet connection message
            self.showMessage(message: Messages.noConnection, isError: true)
        }
    }
    
    // Load more photos if needed
    func loadMorePhotosIfNeeded(for indexPath: IndexPath) {
        if indexPath.item == photoViewModel.photos.count - 1 {
            // Reached the end of current data, load more
            currentPage += 1
            fetchPhotos()
        }
    }
    
    // Refresh button action
    @IBAction func btnRefreshTapped(_ sender: UIBarButtonItem) {
        // Check network connectivity
        if NetworkMonitor.shared.isConnected {
            // Fetch photos
            fetchPhotos()
        } else {
            // Show no internet connection message
            self.showMessage(message: Messages.noConnection, isError: true)
        }
    }
    
    // Retry button action
    @IBAction func btnRetryTapped(_ sender: UIButton) {
        // Check network connectivity
        if NetworkMonitor.shared.isConnected {
            let tag = sender.tag
            let photo = photoViewModel.photos[tag]
            if let cell = self.collectionView.cellForItem(at: IndexPath(item: tag, section: 0)) as? PhotoCell {
                // Configure cell with photo data
                cell.configureWith(photo: photo) { status in
                    if status {
                        // Show no internet connection message
                        self.showMessage(message: Messages.noConnection, isError: true)
                    }
                }
            }
        } else {
            // Show no internet connection message
            self.showMessage(message: Messages.noConnection, isError: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoViewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        let photo = photoViewModel.photos[indexPath.item]
        // Configure cell with photo data
        cell.configureWith(photo: photo) { status in }
        cell.btnRetry.tag = indexPath.item
        cell.lblTitle.text = "\(indexPath.item)"
        // Load more photos if needed
        loadMorePhotosIfNeeded(for: indexPath)
        return cell
    }
}

