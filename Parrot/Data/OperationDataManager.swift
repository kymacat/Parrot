//
//  OperationDataManager.swift
//  Parrot
//
//  Created by Const. on 15.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit


class WriteOperation : Operation {
    var profileVC: ProfileViewController
    var fileName: String
    var data: String
    var isSuccessesed = true
    
    init(_ profileVC: ProfileViewController, fileName: String, data: String) {
        self.profileVC = profileVC
        self.fileName = fileName
        self.data = data
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        if let dir = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask).first {
            

            let path = dir.appendingPathComponent(fileName)
            do {
                try data.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                isSuccessesed = false
            }
        }
    }
}

class ReadOperation : Operation {
    var profileVC: ProfileViewController
    var fileName: String
    var data: String?
    var isSuccessesed = true
    
    init(_ profileVC: ProfileViewController, fileName: String) {
        self.profileVC = profileVC
        self.fileName = fileName
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        
        if let dir = FileManager.default.urls(for: .allLibrariesDirectory, in: .userDomainMask).first {

            let path = dir.appendingPathComponent(fileName)
            
            do {
                data = try String(contentsOf: path, encoding: String.Encoding.utf8)
                
            } catch {
                isSuccessesed = false
            }
        }
    }
}

class SaveImageOperation : Operation {
    var image: UIImage
    
    init(image: UIImage) {
        self.image = image
    }
    
    override func main() {
            
            if isCancelled {
                return
            }
            
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

class LoadImageOperation : Operation {
    
    var image = UIImage()
    override func main() {
            
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            if let im = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent("fileName.png").path) {
                image = im
            }
                
        }
    }
}
