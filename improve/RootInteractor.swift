//
//  RootInteractor.swift
//  improve
//
//  Created by Denis Bezrukov on 24.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

class RootInteractor {
    weak var output: RootInteractorOutput!
}

extension RootInteractor: RootInteractorInput {
    
    func requestInitial() {
//        debugPrint("RootInteractor requestInitial")
    }
}

