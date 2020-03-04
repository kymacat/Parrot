//
//  ViewController.swift
//  Parrot
//
//  Created by Const. on 13.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    // MARK: - UI
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var setProfileImageButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var editingButton: UIButton!
    
    // MARK: - VC Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.textColor = .black
        descriptionLabel.textColor = .black
        
        
        // констрейнты для setProfileButton
        setProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            setProfileImageButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 0),
            setProfileImageButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 0),
            setProfileImageButton.widthAnchor.constraint(equalToConstant: profileImage.frame.width/3),
            setProfileImageButton.heightAnchor.constraint(equalToConstant: profileImage.frame.width/3)
        ])
        
    
        // Размеры шрифтов для nameLabel, descriptionLabel и editingButton
        nameLabel.font = nameLabel.font.withSize(self.view.frame.width/14)
        descriptionLabel.font = descriptionLabel.font.withSize(self.view.frame.width/20)
        editingButton.titleLabel?.font =  editingButton.titleLabel?.font.withSize(self.view.frame.width/20)
        
        editingButton.layer.cornerRadius = 10
        editingButton.layer.borderWidth = 1.5
        editingButton.layer.borderColor = (UIColor.black).cgColor
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        //Закругленные края
        setProfileImageButton.layer.cornerRadius = CGFloat(setProfileImageButton.frame.width/2)
        profileImage.layer.cornerRadius = CGFloat(setProfileImageButton.frame.width/2)
        
        // Картинка для кнопки setProfileImageButton
        let image = UIImageView()
        let imageViewWidth = setProfileImageButton.frame.width
        let imageViewHeigth = setProfileImageButton.frame.height
        let imageFrame = CGRect(x: imageViewWidth/4, y: imageViewHeigth/4, width: imageViewWidth*2/4, height: imageViewHeigth*2/4)
        image.frame = imageFrame
        image.image = UIImage(named: "slr-camera-2-xxl")
        setProfileImageButton.addSubview(image)
    }
    
    // MARK: - Work with user
    
    
    @IBAction func setProfileImageButtonAction(_ sender: Any) {
        print("Выбери изображение для профиля")
        selectionAlert()
    }
    
    func selectionAlert() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Назад", style: .cancel, handler: nil)
        
        let libraryAction = UIAlertAction(title: "Выбрать из галереи", style: .default) { (action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        
        let makePhotoAction = UIAlertAction(title: "Сделать фото", style: .default) { (action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera not available")
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(libraryAction)
        alert.addAction(makePhotoAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - ImagePickerDelegate

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        profileImage.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
