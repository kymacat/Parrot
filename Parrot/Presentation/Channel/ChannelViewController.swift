//
//  ChannelViewController.swift
//  Parrot
//
//  Created by Const. on 01.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import Firebase

class ChannelViewController: UITableViewController {
    
    fileprivate let senderID = "123654"
    fileprivate let reuseIdentifier = "MessageCell"
    
    // MARK: - Private
    
    private var name: String!
    
    func setName(name: String?) {
        if let unrName = name {
            self.name = unrName
        } else {
            self.name = ""
        }
    }
    
    private var messages: [Message] = []
    
    private lazy var db = Firestore.firestore()
    
    private lazy var reference: CollectionReference = {
        guard let channelIdentifier = channel?.identifier else { fatalError() }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()
    
    var channel: Channel?
    
    
    private var firstScroll = true
    private func scrollToBottom() {
        DispatchQueue.main.async { [weak self] in
            if let VC = self {
                if VC.messages.count > 0 {
                    usleep(300000)
                    let indexPath = IndexPath(row: VC.messages.count - 1, section: 0)
                    VC.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        navigationItem.title = name
        
        FirebaseRequests.getMessages(reference: reference, for: self)
    }
    
    func updateMessages(with newMessages: [Message]) {
        messages = newMessages.sorted(by: { (mes1, mes2) -> Bool in
            if mes1.created < mes2.created {
                return true
            }
            return false
        })
        tableView.reloadData()
        if firstScroll {
            scrollToBottom()
            firstScroll = false
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else {return UITableViewCell()}

        let isIncoming: Bool
        
        if messages[indexPath.row].senderID == senderID {
            isIncoming = false
        } else {
            isIncoming = true
        }
        let currMessage = messages[indexPath.row]
        
        let cellModel = MessageCellModel(text: currMessage.content, date: currMessage.created, senderName: currMessage.senderName, isIncoming: isIncoming)
        cell.configure(with: cellModel)

        return cell
    }

}
