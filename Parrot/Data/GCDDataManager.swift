//
//  GCDDataManager.swift
//  Parrot
//
//  Created by Const. on 15.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class GCDDataManager {
    
    static func writeToFile(_ controller: ProfileViewController, name: String, data: String) {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            if let dir = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask).first {

                let path = dir.appendingPathComponent(name)
                
                do {
                    try data.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                    DispatchQueue.main.async {
                        controller.showSuccessesAlert()
                        controller.activityIndicator.stopAnimating()
                        controller.presentMode()
                    }
                } catch {
                    
                    DispatchQueue.main.async {
                        controller.showErrorAlert()
                        controller.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    
    static func saveImage(image: UIImage) {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
                return
            }
            guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
                return
            }
            do {
                try data.write(to: directory.appendingPathComponent("fileName.png")!)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getSavedImage(controller: ProfileViewController) {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                DispatchQueue.main.async {
                    controller.profileImage.image = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("fileName.png").path)
                }
            }
        }
    }
    
    
    static func readFromTheFile(_ controller: ProfileViewController, name: String) {
        let queue = DispatchQueue.global(qos: .utility)
        
        queue.async {
            if let dir = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask).first {

                let path = dir.appendingPathComponent(name)
                
                do {
                    let text = try String(contentsOf: path, encoding: String.Encoding.utf8)
                    
                    DispatchQueue.main.async {
                        if name == "Name.txt" {
                            controller.nameLabel.text = text
                        } else {
                            controller.descriptionTextView.text = text
                        }
                    }
                } catch {
                    print("Ошибка чтения")
                }
            }
        }
    }
        
}
