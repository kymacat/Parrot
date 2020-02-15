//
//  ViewController.swift
//  Parrot
//
//  Created by Const. on 13.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if SHOWLIFECYCLE
        print("ViewController loaded but still disappeared")
        print(#function + "\n")
        #endif
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if SHOWLIFECYCLE
        print("ViewController will move from <Disappeared> to <Appearing>")
        print(#function + "\n")
        #endif
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        #if SHOWLIFECYCLE
        print("View size will change")
        print(#function + "\n")
        #endif
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        #if SHOWLIFECYCLE
        print("View size changed")
        print(#function + "\n")
        #endif
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        #if SHOWLIFECYCLE
        print("ViewController moved from <Appearing> to <Appeared>")
        print(#function + "\n")
        #endif
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        #if SHOWLIFECYCLE
        print("ViewController will move from <Appeared> to <Disappearing>")
        print(#function + "\n")
        #endif
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        #if SHOWLIFECYCLE
        print("ViewController moved from <Disappearing> to <Disappeared>")
        print(#function + "\n")
        #endif
    }

}
