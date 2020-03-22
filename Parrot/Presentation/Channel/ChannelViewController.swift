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
    private var groupedMessages: [[Message]] = []
    
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
                if VC.groupedMessages.count > 0, let last = VC.groupedMessages.last {
                    usleep(300000)
                    let indexPath = IndexPath(row: last.count - 1, section: VC.groupedMessages.count - 1)
                    VC.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
    
    
    private func groupMessagesByDate() {
        let groupedMessages = Dictionary(grouping: messages) { element -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.init(identifier: "ru_RU")
            dateFormatter.dateFormat = "dd MMM"
            return dateFormatter.string(from: element.created)
        }
        
        var newGroupMessages: [[Message]] = []
        groupedMessages.keys.forEach { key in
            if let values = groupedMessages[key] {
                newGroupMessages.append(values)
            }
        }
        self.groupedMessages = newGroupMessages.sorted { (values1, values2) -> Bool in
            if let first1 = values1.first, let first2 = values2.first {
                if first1.created < first2.created {
                    return true
                }
            }
            return false
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
        groupMessagesByDate()
        tableView.reloadData()
        if firstScroll {
            scrollToBottom()
            firstScroll = false
        }
    }

    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupedMessages.count
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMessages[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else {return UITableViewCell()}

        let isIncoming: Bool
        
        if groupedMessages[indexPath.section][indexPath.row].senderID == senderID {
            isIncoming = false
        } else {
            isIncoming = true
        }
        let currMessage = groupedMessages[indexPath.section][indexPath.row]
        
        let cellModel = MessageCellModel(text: currMessage.content, date: currMessage.created, senderName: currMessage.senderName, isIncoming: isIncoming)
        cell.configure(with: cellModel)

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = HeaderLabel()
        label.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textColor = .white
        label.textAlignment = .center
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMM"
        if let date = groupedMessages[section].first?.created {
            label.text = dateFormatter.string(from: date)
        }
        
        let conteinerView = UIView()
        conteinerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerXAnchor.constraint(equalTo: conteinerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: conteinerView.centerYAnchor).isActive = true
        
        return conteinerView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

}

class HeaderLabel : UILabel {
    override var intrinsicContentSize: CGSize {
        let originalIntrinsicSize = super.intrinsicContentSize
        let height = originalIntrinsicSize.height + 12
        layer.cornerRadius = height/2
        clipsToBounds = true
        return CGSize(width: originalIntrinsicSize.width + 20, height: height)
    }
}
