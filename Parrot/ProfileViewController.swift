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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - Work with user
    
    
    @IBAction func setProfileImageButtonAction(_ sender: Any) {
        
    }
    
}
