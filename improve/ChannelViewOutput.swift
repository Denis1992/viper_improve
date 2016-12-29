//
//  ChannelViewOutput.swift
//  improve
//
//  Created by Denis Bezrukov on 01.09.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation

protocol ChannelViewOutput {
    func requireObject(inout object:ItemModel, ForIndexPath indexPath:NSIndexPath)
    func requireRows(inout rows:Int, ForSection section:Int)
    func requireSections(inout sections:Int)
    func requireTitleForHeader(inout title:String, InSection section:Int)
    func selectItem(AtIndexPath indexPath: NSIndexPath)
}
