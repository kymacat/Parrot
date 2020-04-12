//
//  ServicesAssembly.swift
//  Parrot
//
//  Created by Const. on 12.04.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation
protocol IServicesAssembly {
    var allChannelsService: IAllChannelsService { get }
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var allChannelsService: IAllChannelsService = AllChannelsService(firebaseRequests: coreAssembly.firebaseRequests)
}
