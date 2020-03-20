//
//  ChannelsViewController.swift
//  Parrot
//
//  Created by Const. on 28.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import Firebase


class ChannelsViewController: UITableViewController {
    
    fileprivate let reuseIdentifier = String(describing: ChannelCell.self)
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    var channels: [Channel] = []
    var updatedChannels: [Channel] = []
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reference.document("1ecgy8fmLfHWNJxntSQm").delete()
        FirebaseRequests.getChannels(reference: reference, for: self)
        
        //Блокировка портретного режима
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait
        }
        
        navigationItem.title = "Tinkoff Chat"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.heavy)]
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addChannel(sender:)))
        button.tintColor = .black
        
        navigationItem.rightBarButtonItem = button
        
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        
        /*
        //Разделение данных на доступных к переписке в данный момент, и на недоступных
        onlineList = data.filter{$0.isOnline}
        offlineList = data.filter{!$0.isOnline}
        
        //Сортировка диалогов по времени
        let sortClosure: (ConversationCellModel, ConversationCellModel) -> Bool = {
            guard let date1 = $0.date else { return false }
            guard let date2 = $1.date else { return true }
            return date1 > date2
        }
        onlineList.sort(by: sortClosure)
        offlineList.sort(by: sortClosure)
        */
        
    }
    
    // MARK: - Add channel
    
    @objc func addChannel(sender: UIButton) {
        let alertController = UIAlertController(title: "Add new channel", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                if text.replacingOccurrences(of: " ", with: "") != "" {
                    let trueName = text.trimmingCharacters(in: .whitespaces)
                    
                    if let ref = self?.reference {
                        FirebaseRequests.addChannel(reference: ref, name: trueName)
                    }
                    
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Channel name"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toConversation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toConversation"{
            
            if let destinationViewController = segue.destination as? ChannelViewController {
                if let indexPath = tableView.indexPathForSelectedRow {
                    if let cell = tableView.cellForRow(at: indexPath) as? ChannelCell {
                        
                        destinationViewController.setName(name: cell.nameLabel.text)
                        
                        if cell.messageLabel.text == "No messages yet" {
                            destinationViewController.setFlag(flag: false)
                        } else {
                            destinationViewController.setFlag(flag: true)
                            destinationViewController.data.append(MessageCellModel(text: cell.messageLabel.text!, isIncoming: true))
                        }
                    }
                }
                
            }
        }

    }
}

// MARK: - Table view data source

extension ChannelsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return channels.count
        } else {
            return channels.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ChannelCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.configure(with: channels[indexPath.row])
            let gradient = GradientView()
            gradient.configure(startColor: .systemYellow, endColor: .white, startLocation: 0, endLocation: 1, startPoint: CGPoint(x: -0.5, y: 0), endPoint: CGPoint(x: 1, y: 0))
            cell.backgroundView = gradient
        } else {
            cell.configure(with: channels[indexPath.row])
            cell.backgroundView = UIView()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 25))
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 25))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.systemYellow
        if section == 0 {
            label.text = "Active"
        } else {
            label.text = "Inactive"
        }
        view.addSubview(label)
        return view
    }
    
}
