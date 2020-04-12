//
//  ChannelsViewController.swift
//  Parrot
//
//  Created by Const. on 28.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import CoreData

class ChannelsViewController: UITableViewController {
    
    private let model = ChannelsVCModel(senderName: "Vlad Yandola")
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.fetchedResultsController.delegate = self
        
        do {
            try model.fetchedResultsController.performFetch()
            model.fetchChannels()
        } catch {
            print(error)
        }
        
        
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
        
        tableView.register(UINib(nibName: model.reuseIdentifier, bundle: nil), forCellReuseIdentifier: model.reuseIdentifier)
        
        
        
        
    }
    
    
    // MARK: - Add channel
    
    
    
    // MARK: - !
    @objc func addChannel(sender: UIButton) {
        let alertController = UIAlertController(title: "Add new channel", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { [weak self] action in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                if text.replacingOccurrences(of: " ", with: "") != "" {
                    let trueName = text.trimmingCharacters(in: .whitespaces)
                    
                    self?.model.addChannel(with: trueName)

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
                        
                        let currChannel = model.fetchedResultsController.object(at: indexPath)
                        let channel = ChannelModel(identifier: currChannel.identifier, name: currChannel.name, lastMessage: currChannel.lastMessage, activeDate: currChannel.activeDate, isActive: currChannel.isActive)
                        
                        destinationViewController.channel = channel
                        
                    }
                }
                
            }
        }
        
        if segue.identifier == "toProfile" {
            if let destinationViewController = segue.destination as? ProfileViewController {
                
                destinationViewController.fileManager = CoreDataFileManager()
                
            }
        }

    }
}

// MARK: - Table view data source

extension ChannelsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = model.fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = model.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: model.reuseIdentifier, for: indexPath) as? ChannelCell else { return UITableViewCell() }
        
        let channel = model.fetchedResultsController.object(at: indexPath)
        let cellModel = ChannelCellModel(name: channel.name, lastMessage: channel.lastMessage, activeDate: channel.activeDate, identifier: channel.identifier)
        cell.configure(with: cellModel)
        if channel.isActive {
            let gradient = GradientView()
            gradient.configure(startColor: .systemYellow, endColor: .white, startLocation: 0, endLocation: 1, startPoint: CGPoint(x: -0.5, y: 0), endPoint: CGPoint(x: 1, y: 0))
            cell.backgroundView = gradient
        } else {
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
        if tableView.numberOfSections == 1 {
            if let channel = model.fetchedResultsController.sections?.first?.objects?.first as? Channel {
                if channel.isActive {
                    label.text = "Active"
                } else {
                    label.text = "Inactive"
                }
            }
        } else {
            if section == 0 {
                label.text = "Active"
            } else {
                label.text = "Inactive"
            }
        }
        
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let cell = tableView.cellForRow(at: indexPath) as? ChannelCell,
                let identifier = cell.identifier {
                model.deleteChannel(with: identifier)
            }
            
            
        }
    }
    
}

// MARK: - FetchedControllerDelegate
extension ChannelsViewController : NSFetchedResultsControllerDelegate {
    
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.beginUpdates()
        }
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        DispatchQueue.main.async { [weak self] in
            switch type {
            case .insert:
                self?.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            case .delete:
                self?.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            default:
                return
            }
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async { [weak self] in
            switch type {
            case .insert:
                if let indexPath = newIndexPath {
                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            case .move:
                if let indexPath = indexPath {
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                if let newIndexPath = newIndexPath {
                    self?.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .delete:
                if let indexPath = indexPath {
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            case .update:
                if let indexPath = indexPath {
                    
                    if let cell = self?.tableView.cellForRow(at: indexPath) as? ChannelCell,
                       let channel = self?.model.fetchedResultsController.object(at: indexPath) {
                        
                        let cellModel = ChannelCellModel(name: channel.name, lastMessage: channel.lastMessage, activeDate: channel.activeDate, identifier: channel.identifier)
                        cell.configure(with: cellModel)
                    }
                    
                    
                }
            @unknown default:
                fatalError()
            }
        
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.endUpdates()
        }
    }
}
