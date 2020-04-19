//
//  ImagesViewController.swift
//  Parrot
//
//  Created by Const. on 17.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, IImagesVCDelegate, IImageCellDelegate {
    
    private let reuseIdentifier = String(describing: ImageCell.self)
    
    var collectionView: UICollectionView?
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 15, left: 15, bottom: 40, right: 15)
    
    //Dependencies
    let model: IImagesVCModel
    let presentationAssembly: IPresentationAssembly
    
    private var dataSource: [ImageCellModel] = []
    private var cachedDataSource: [String: UIImage] = [:]
    
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .black
        indicator.style = .whiteLarge
        return indicator
    }()
    
    private let unwindController: ProfileViewController
    
    init(model: IImagesVCModel, presentationAssembly: IPresentationAssembly, unwindController: ProfileViewController) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        self.unwindController = unwindController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        model.fetchImages()
        
        // MARK: IndicatorView
        view.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        loadingIndicator.startAnimating()
          
    }
    
    // MARK: - Private
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        
        collectionView?.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.white
               
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        self.view.addSubview(collectionView ?? UICollectionView())
    }
    
    
    // MARK: - IImagesVCDelegate
    
    func setup(dataSource: [ImageCellModel]) {
        self.dataSource = dataSource

        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - IImageCellDelegate
    
    func cacheImage(imageUrl: String, image: UIImage) {
        cachedDataSource[imageUrl] = image
    }
    
    func getImage(imageUrl: String, completionHandler: @escaping (UIImage?, String, String?) -> Void) {
        model.getImageForCell(imageUrl: imageUrl, completionHandler: completionHandler)
    }
}

// MARK: UICollectionViewDataSource

extension ImagesViewController : UICollectionViewDataSource {


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        
        let model = dataSource[indexPath.row]
        
        if let image = cachedDataSource[model.imageUrl] {
            cell.imageView.image = image
        } else {
            cell.delegate = self
            cell.configure(with: dataSource[indexPath.row])
        }
        
        return cell
    }

}
// MARK: - UICollectionViewDelegate

extension ImagesViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCell {
            if cell.imageView.image != UIImage(named: "placeholder") {
                if let image = cell.imageView.image {
                    unwindController.profileImage.image = image
                    unwindController.saveImage(image: image)
                }
                self.dismiss(animated: true, completion: nil)
            }
            
            
        }
        
    }
}

// MARK: - Collection View Flow Layout Delegate
extension ImagesViewController : UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}

