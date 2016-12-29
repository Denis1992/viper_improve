//
//  SelectView.swift
//  improve
//
//  Created by Denis Bezrukov on 19.08.16.
//  Copyright © 2016 Denis Bezrukov. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

protocol SelectViewInput:class {
    
    func actionDataUpdated(updates:DataUpdates?)
}

protocol SelectViewOutput {
    
    func actionAddChannel()
    func actionViewLoaded()
    func selectChannel(AtIndexPath indexPath:NSIndexPath)
    func requireObject(inout object:ChannelModel, ForIndexPath indexPath:NSIndexPath)
    func requireRows(inout rows:Int, ForSection section:Int)
    func requireSections(inout sections:Int)
}

class SelectView:ASViewController {
    
    var output:SelectViewOutput?
    
    var tableNode: ASTableNode {
        return self.node as! ASTableNode
    }
    
    init() {
        super.init(node: ASTableNode(style:.Grouped))
        tableNode.delegate = self
        tableNode.dataSource = self
        title = "КАНАЛЫ"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:.Add, target:self, action:#selector(SelectView.add))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        output?.actionViewLoaded()
    }

    @objc private func add() {

        output?.actionAddChannel()
    }
}

extension SelectView:SelectViewInput {

    func actionDataUpdated(updates:DataUpdates?) {
        
        guard let updates = updates else { return }
        tableNode.view.beginUpdates()
        for set in updates.sections.delete { tableNode.view.deleteSections(set, withRowAnimation:.Fade) }
        for set in updates.sections.insert { tableNode.view.insertSections(set, withRowAnimation:.Fade) }
        if updates.rows.delete.count > 0 { tableNode.view.deleteRowsAtIndexPaths(updates.rows.delete, withRowAnimation:.Fade) }
        if updates.rows.insert.count > 0 { tableNode.view.insertRowsAtIndexPaths(updates.rows.insert, withRowAnimation:.Fade) }
        if updates.rows.reload.count > 0 { tableNode.view.reloadRowsAtIndexPaths(updates.rows.reload, withRowAnimation:.Fade) }
        tableNode.view.endUpdates()
    }
}


// MARK: - ASTableDataSource, ASTableDelegate

extension SelectView: ASTableDataSource, ASTableDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        var sections:Int = 0
        output?.requireSections(&sections)
        return sections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows:Int = 0
        output?.requireRows(&rows, ForSection:section)
        return rows
    }
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
    
        var object:ChannelModel = ChannelModel()
        output?.requireObject(&object, ForIndexPath:indexPath)
        
        let cellNodeBlock = { () -> ASCellNode in
//            return TailLoadingCellNode()
            let node = ASTextCellNode()
            node.text = object.title!
            return node
        }
        
        return cellNodeBlock
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        output?.selectChannel(AtIndexPath: indexPath)
        tableNode.view.deselectRowAtIndexPath(indexPath, animated: true)
    }
}



