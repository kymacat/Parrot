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
    
    fileprivate let senderName = "Vlad Yandola"
    fileprivate let reuseIdentifier = String(describing: ChannelCell.self)
    
    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")
    
    private var channels: [Channel] = []
    
    private var activeChannels: [Channel] = []
    private var inactiveChannels: [Channel] = []
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //reference.document("IhQ802dVqmplzw9l5BEV").delete()
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
        
        
        
    }
    
    // MARK: - Update channels
    
    func updateChannels(with newChannels: [Channel]) {
        channels = newChannels
        var newActiveChannels: [Channel] = []
        var newInactiveChannels: [Channel] = []
        newActiveChannels = channels.filter { (channel) -> Bool in
            if let date = channel.activeDate {
                if date > Date() - (60*10) {
                    return true
                }
            }
            newInactiveChannels.append(channel)
            return false
        }
        
        //Сортировка диалогов по времени
        let sortClosure: (Channel, Channel) -> Bool = {
            guard let date1 = $0.activeDate else { return false }
            guard let date2 = $1.activeDate else { return true }
            return date1 > date2
        }
        newActiveChannels.sort(by: sortClosure)
        newInactiveChannels.sort(by: sortClosure)
        activeChannels = newActiveChannels
        inactiveChannels = newInactiveChannels
        tableView.reloadData()
    }
    
    // MARK: - Add channel
    
    @objc func addChannel(sender: UIButton) {
        let alertController = UIAlertController(title: "Add new channel", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                if text.replacingOccurrences(of: " ", with: "") != "" {
                    let trueName = text.trimmingCharacters(in: .whitespaces)
                    
                    if let ref = self?.reference, let name = self?.senderName {
                        FirebaseRequests.addChannel(reference: ref, name: trueName, senderName: name)
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
                        
                        if indexPath.section == 0 {
                            destinationViewController.channel = activeChannels[indexPath.row]
                        } else {
                            destinationViewController.channel = inactiveChannels[indexPath.row]
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
            return activeChannels.count
        } else {
            return inactiveChannels.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ChannelCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            let currChannel = activeChannels[indexPath.row]
            let cellModel = ChannelCellModel(name: currChannel.name, lastMessage: currChannel.lastMessage, activeDate: currChannel.activeDate)
            cell.configure(with: cellModel)
            let gradient = GradientView()
            gradient.configure(startColor: .systemYellow, endColor: .white, startLocation: 0, endLocation: 1, startPoint: CGPoint(x: -0.5, y: 0), endPoint: CGPoint(x: 1, y: 0))
            cell.backgroundView = gradient
        } else {
            let currChannel = inactiveChannels[indexPath.row]
            let cellModel = ChannelCellModel(name: currChannel.name, lastMessage: currChannel.lastMessage, activeDate: currChannel.activeDate)
            cell.configure(with: cellModel)
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
            if activeChannels.count == 0 {
                return UIView()
            }
            label.text = "Active"
        } else {
            if inactiveChannels.count == 0 {
                return UIView()
            }
            label.text = "Inactive"
        }
        view.addSubview(label)
        return view
    }
    
}
