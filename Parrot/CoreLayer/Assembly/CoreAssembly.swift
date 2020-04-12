//
//  CoreAssembly.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var firebaseRequests: FirebaseRequests { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var firebaseRequests: FirebaseRequests = Requests()
}
