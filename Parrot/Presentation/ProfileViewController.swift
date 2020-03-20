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
    
    weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - VC Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillView()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
        
        GCDDataManager.readFromTheFile(self, name: nameFile)
        GCDDataManager.readFromTheFile(self, name: descriptionFile)
        
        GCDDataManager.getSavedImage(controller: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40),
           profileImage.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
           profileImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.78),
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
            descriptionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
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
        
        
        var constant: CGFloat = 5
        
        //constant для экрана, большего чем у iPhone 8
        if view.frame.height > 736 {
            constant *= 12
        }
        editingButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            editingButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 40),
            editingButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -40),
            editingButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -29),
            editingButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: constant),
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
        scrollView.addSubview(nameTextField)
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameTextField.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor)
        ])
        
        nameTextField.isHidden = true
        
        
        // MARK: editDescriptionTextView
        let textView = UITextView()
        textView.textAlignment = .center
        textView.font = descriptionTextView.font
        textView.text = descriptionTextView.text
        textView.layer.cornerRadius = 10
        textView.backgroundColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        
        editingDescriptionTextView = textView
        scrollView.addSubview(editingDescriptionTextView)
        
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
        scrollView.addSubview(GCDSaveButton)
        
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
        scrollView.addSubview(OperationSaveButton)
        
        OperationSaveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            OperationSaveButton.trailingAnchor.constraint(equalTo: editingButton.trailingAnchor),
            OperationSaveButton.bottomAnchor.constraint(equalTo: editingButton.bottomAnchor),
            OperationSaveButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            OperationSaveButton.topAnchor.constraint(equalTo: editingButton.topAnchor)
        ])
        
        OperationSaveButton.isHidden = true
        
        // MARK: IndicatorView
        
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .black
        indicator.style = .whiteLarge
        
        activityIndicator = indicator
        scrollView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            activityIndicator.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20)
        ])
        
    }
    
    
    // MARK: - Frontend
    
    // MARK: Вспомогательные поля
    var isPresentMode = true
    var isAlerted = false
    let nameFile = "Name.txt"
    let descriptionFile = "Description.txt"
    
    
    // MARK: setProfileImage
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
    
    // MARK: editProfileButton
    
    @objc func editProfileButton(sender: UIButton) {
        nameTextField.text = nameLabel.text
        editingDescriptionTextView.text = descriptionTextView.text
        
        editingMode()
    }
    
    // MARK: saveGCDButton
        
    @objc func saveGCDButton(sender: UIButton) {
        if !activityIndicator.isAnimating {
        
            //Если данные не менялись, то ничего не сохраняю
            if (nameLabel.text == nameTextField.text) && (descriptionTextView.text == editingDescriptionTextView.text) {
                presentMode()
                
                hideKeyboard()
                return
            }
            
            if nameLabel.text != nameTextField.text {
                if let nameText = nameTextField.text {
                    activityIndicator.startAnimating()
                    GCDDataManager.writeToFile(self, name: nameFile, data: nameText)
                }
            }
            
            if descriptionTextView.text != editingDescriptionTextView.text {
                if let descrText = editingDescriptionTextView.text {
                    activityIndicator.startAnimating()
                    GCDDataManager.writeToFile(self, name: descriptionFile, data: descrText)
                }
            }
        }
            
        hideKeyboard()
            
    }
    
    // MARK: saveOperationButton
        
    @objc func saveOperationButton(sender: UIButton) {
        if !activityIndicator.isAnimating {
            
            //Если данные не менялись, то ничего не сохраняю
            if (nameLabel.text == nameTextField.text) && (descriptionTextView.text == editingDescriptionTextView.text) {
                presentMode()
                
                hideKeyboard()
                return
            }
            
            let operationQueue: OperationQueue = OperationQueue()
            
            if nameLabel.text != nameTextField.text {
                if let nameText = nameTextField.text {
                    activityIndicator.startAnimating()
                    let operation = WriteOperation(self, fileName: nameFile, data: nameText)
                    operation.completionBlock = {
                        DispatchQueue.main.async { [weak self] in
                            if operation.isSuccessesed {
                                self?.showSuccessesAlert()
                                self?.activityIndicator.stopAnimating()
                                self?.presentMode()
                            } else {
                                self?.showErrorAlert()
                                self?.activityIndicator.stopAnimating()
                            }
                        }
                    }
                    operationQueue.addOperation(operation)
                }
            }
            
            if descriptionTextView.text != editingDescriptionTextView.text {
                if let descrText = editingDescriptionTextView.text {
                    activityIndicator.startAnimating()
                    let operation = WriteOperation(self, fileName: descriptionFile, data: descrText)
                    operation.completionBlock = {
                        DispatchQueue.main.async { [weak self] in
                            if operation.isSuccessesed {
                                self?.showSuccessesAlert()
                                self?.activityIndicator.stopAnimating()
                                self?.presentMode()
                            } else {
                                self?.showErrorAlert()
                                self?.activityIndicator.stopAnimating()
                            }
                        }
                    }
                    operationQueue.addOperation(operation)
                }
            }
        
        }
        hideKeyboard()
    }
    
    // MARK: Alerts
    
    @objc func showSuccessesAlert() {
        if !isAlerted {
            isAlerted = true
            let alert = UIAlertController(title: "Уведомление", message: "Изменения сохранены", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] action in
                self?.isAlerted = false
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func showErrorAlert() {
        if !isAlerted {
            isAlerted = true
            let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так и данные не сохранились", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { [weak self] action in
                self?.presentMode()
            }))
            
            alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] action in
                
                if let nameText = self?.nameTextField.text, let VC = self {
                    GCDDataManager.writeToFile(VC, name: VC.nameFile, data: nameText)
                }
                
                if let descrText = self?.editingDescriptionTextView.text, let VC = self {
                    GCDDataManager.writeToFile(VC, name: VC.descriptionFile, data: descrText)
                }
                self?.isAlerted = false
            }))

            self.present(alert, animated: true)
        }
        
    }
    
    // MARK: - Backend
    
    
    
    // MARK: profile modes
    
    func changeMode() {
        nameTextField.isHidden = !nameTextField.isHidden
        editingDescriptionTextView.isHidden = !editingDescriptionTextView.isHidden
        nameLabel.isHidden = !nameLabel.isHidden
        descriptionTextView.isHidden = !descriptionTextView.isHidden
        isPresentMode = false
    }
    
    func editingMode() {

        changeMode()
        editingButton.isHidden = true
        GCDSaveButton.isHidden = false
        OperationSaveButton.isHidden = false
    }
    
    func presentMode() {
        if !isPresentMode {
            changeMode()
            editingButton.isHidden = false
            OperationSaveButton.isHidden = true
            GCDSaveButton.isHidden = true
            isPresentMode = true
            
            
            GCDDataManager.readFromTheFile(self, name: nameFile)
            GCDDataManager.readFromTheFile(self, name: descriptionFile)
            
            
            
        }
    }
    
    // MARK: keyboard notification
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
    }
    
    @objc func hideKeyboard() {
        scrollView.endEditing(true)
    }
    
    
}

// MARK: - ImagePickerDelegate

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        profileImage.image = image
        
        GCDDataManager.saveImage(image: image)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}