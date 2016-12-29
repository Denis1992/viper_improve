//
//  InfoInteractorOutput.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

protocol InfoInteractorOutput: class {
    func recieve(WithItem item:ItemModel)
    func openInBrowser(WithUrl url: NSURL)
}
