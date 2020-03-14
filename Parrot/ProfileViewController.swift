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
    
    weak var scrollView: UIScrollView!
    
    weak var profileImage: UIImageView!
    
    weak var setProfileImageButton: CustomButton!
    
    weak var nameLabel: UILabel!
    weak var nameTextField: UITextField!
    
    
    weak var descriptionTextView: UITextView!
    weak var editingDescriptionTextView: UITextView!
    
    weak var editingButton: UIButton!
    
    weak var GCDSaveButton: CustomButton!
    weak var OperationSaveButton: CustomButton!
    
    
    // MARK: - VC Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //Закругленные края
        setProfileImageButton.layer.cornerRadius = CGFloat(setProfileImageButton.frame.width/2)
        profileImage.layer.cornerRadius = CGFloat(setProfileImageButton.frame.width/2)
        
    }
    
    // MARK: - Fill View
    
    private func fillView() {
        
        // MARK: Scroll View
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scrollView = scroll
        
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // MARK: profile Image
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "placeholder-user")
        imageView.clipsToBounds = true
        
        profileImage = imageView
        
        scrollView.addSubview(profileImage)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 41),
           profileImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
           profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
           profileImage.heightAnchor.constraint(equalTo: profileImage.widthAnchor)
        ])
        
        // MARK: setImageButton
        let setImageButton = CustomButton()
        
        setImageButton.changeBackroundColor(UIColor(red: 61/255, green: 119/255, blue: 236/255, alpha: 1))
        setImageButton.addTarget(self, action: #selector(setProfileImageButtonAction(sender:)), for: .touchUpInside)
        
        setProfileImageButton = setImageButton
        
        scrollView.addSubview(setProfileImageButton)
        
        setProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            setProfileImageButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            setProfileImageButton.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor),
            setProfileImageButton.widthAnchor.constraint(equalTo: profileImage.widthAnchor, multiplier: 1/4),
            setProfileImageButton.heightAnchor.constraint(equalTo: profileImage.heightAnchor, multiplier: 1/4)
        ])
            
        // MARK: Картинка для imButton
        let image = UIImageView()
        image.image = UIImage(named: "slr-camera-2-xxl")
        setProfileImageButton.addSubview(image)
            
        image.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint.activate([
            image.trailingAnchor.constraint(equalTo: setProfileImageButton.trailingAnchor, constant: -18),
            image.bottomAnchor.constraint(equalTo: setProfileImageButton.bottomAnchor, constant: -18),
            image.leadingAnchor.constraint(equalTo: setProfileImageButton.leadingAnchor, constant: 18),
            image.topAnchor.constraint(equalTo: setProfileImageButton.topAnchor, constant: 18)
        ])
        
        // MARK: nameLabel
        
        let nLabel = UILabel()
        nLabel.textAlignment = .center
        nLabel.textColor = .black
        nLabel.font = UIFont.systemFont(ofSize: self.view.frame.width/14, weight: UIFont.Weight.heavy)
        nLabel.text = "Владислав Яндола"
        
        nameLabel = nLabel
        scrollView.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            nameLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 14)
        ])
        
        // MARK: descriptionTextView
        
        let dTextView = UITextView()
        dTextView.textAlignment = .center
        dTextView.textColor = .black
        dTextView.font =
            UIFont.systemFont(ofSize: self.view.frame.width/20, weight: UIFont.Weight.medium)

        dTextView.text = "Люблю программировать под iOS, изучать что-то новое и не стоять на месте"
        dTextView.isEditable = false
        dTextView.isSelectable = false

        descriptionTextView = dTextView
        scrollView.addSubview(descriptionTextView)

        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            descriptionTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            descriptionTextView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35)
        ])
        
        
        // MARK: editingButton
        let eButton = UIButton()
        eButton.setTitle("Редактировать", for: .normal)
        eButton.setTitleColor(.black, for: .normal)
        eButton.titleLabel?.font =  eButton.titleLabel?.font.withSize(self.view.frame.width/20)
        eButton.layer.cornerRadius = 10
        eButton.layer.borderWidth = 1.5
        eButton.layer.borderColor = (UIColor.black).cgColor
        eButton.addTarget(self, action: #selector(editProfileButton(sender:)), for: .touchUpInside)

        editingButton = eButton
        scrollView.addSubview(editingButton)

        editingButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            editingButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            editingButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            editingButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -29),
            editingButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 8),
            editingButton.widthAnchor.constraint(equalTo: editingButton.heightAnchor, multiplier: 120/17)
        ])
        
        
        
        // MARK: nameTextField
        let textField = UITextField()
        textField.textAlignment = .center
        textField.font = nameLabel.font
        textField.text = nameLabel.text
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        nameTextField = textField
        view.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor)
        ])
        
        nameTextField.isHidden = true
        
        
        // MARK: descriptionTextView
        let textView = UITextView()
        textView.textAlignment = .center
        textView.font = descriptionTextView.font
        textView.text = descriptionTextView.text
        textView.layer.cornerRadius = 10
        textView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        editingDescriptionTextView = textView
        view.addSubview(editingDescriptionTextView)
        
        editingDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editingDescriptionTextView.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor),
            editingDescriptionTextView.bottomAnchor.constraint(equalTo: descriptionTextView.bottomAnchor),
            editingDescriptionTextView.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
            editingDescriptionTextView.topAnchor.constraint(equalTo: descriptionTextView.topAnchor)
        ])
        
        editingDescriptionTextView.isHidden = true
        
        
        // MARK: GCDSaveButton
        let GCDButton = CustomButton()
        GCDButton.changeBackroundColor(UIColor(red: 61/255, green: 119/255, blue: 236/255, alpha: 1))
        GCDButton.layer.cornerRadius = editingButton.layer.cornerRadius
        GCDButton.titleLabel?.font = editingButton.titleLabel?.font
        GCDButton.setTitle("GCD", for: .normal)
        GCDButton.setTitleColor(.white, for: .normal)
        
        GCDButton.addTarget(self, action: #selector(saveGCDButton(sender:)), for: .touchUpInside)
        
        GCDButton.layer.cornerRadius = 10
        
        
        
        GCDSaveButton = GCDButton
        view.addSubview(GCDSaveButton)
        
        GCDSaveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            GCDSaveButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            GCDSaveButton.bottomAnchor.constraint(equalTo: editingButton.bottomAnchor),
            GCDSaveButton.leadingAnchor.constraint(equalTo: editingButton.leadingAnchor),
            GCDSaveButton.topAnchor.constraint(equalTo: editingButton.topAnchor)
        ])
        
        GCDSaveButton.isHidden = true
        
        
        // MARK: OperationSaveButton
        
        let OperationButton = CustomButton()
        OperationButton.changeBackroundColor(UIColor(red: 61/255, green: 119/255, blue: 236/255, alpha: 1))
        OperationButton.layer.cornerRadius = editingButton.layer.cornerRadius
        OperationButton.titleLabel?.font = editingButton.titleLabel?.font
        OperationButton.setTitle("Operation", for: .normal)
        OperationButton.setTitleColor(.white, for: .normal)
        
        OperationButton.addTarget(self, action: #selector(saveOperationButton(sender:)), for: .touchUpInside)
        
        OperationButton.layer.cornerRadius = 10
        
        
        
        OperationSaveButton = OperationButton
        view.addSubview(OperationSaveButton)
        
        OperationSaveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            OperationSaveButton.trailingAnchor.constraint(equalTo: editingButton.trailingAnchor),
            OperationSaveButton.bottomAnchor.constraint(equalTo: editingButton.bottomAnchor),
            OperationSaveButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            OperationSaveButton.topAnchor.constraint(equalTo: editingButton.topAnchor)
        ])
        
        OperationSaveButton.isHidden = true
        
        
        
        
    }
    
    // MARK: - Work with user
    
    
    @objc func setProfileImageButtonAction(sender: UIButton) {
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
    
    @objc func editProfileButton(sender: UIButton) {
            nameTextField.isHidden = !nameTextField.isHidden
            editingDescriptionTextView.isHidden = !editingDescriptionTextView.isHidden
            nameLabel.isHidden = !nameLabel.isHidden
            descriptionTextView.isHidden = !descriptionTextView.isHidden

            descriptionTextView.text = editingDescriptionTextView.text

            editingButton.isHidden = true
            GCDSaveButton.isHidden = false
            OperationSaveButton.isHidden = false
            
        }
        
        @objc func saveGCDButton(sender: UIButton) {
            nameTextField.isHidden = !nameTextField.isHidden
            editingDescriptionTextView.isHidden = !editingDescriptionTextView.isHidden
            nameLabel.isHidden = !nameLabel.isHidden
            descriptionTextView.isHidden = !descriptionTextView.isHidden
            
            descriptionTextView.text = editingDescriptionTextView.text
            
            editingButton.isHidden = false
            OperationSaveButton.isHidden = true
            GCDSaveButton.isHidden = true
            
            
        }
        
        @objc func saveOperationButton(sender: UIButton) {
            nameTextField.isHidden = !nameTextField.isHidden
            editingDescriptionTextView.isHidden = !editingDescriptionTextView.isHidden
            nameLabel.isHidden = !nameLabel.isHidden
            descriptionTextView.isHidden = !descriptionTextView.isHidden
            
            descriptionTextView.text = editingDescriptionTextView.text
            
            editingButton.isHidden = false
            OperationSaveButton.isHidden = true
            GCDSaveButton.isHidden = true
            
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
