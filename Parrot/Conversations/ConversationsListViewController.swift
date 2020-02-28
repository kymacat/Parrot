//
//  ConversationsListViewController.swift
//  Parrot
//
//  Created by Const. on 28.02.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

private let reuseIdentifier = String(describing: ConversationCell.self)

class ConversationsListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //Блокировка портретного режима
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait
        }
        
        tableView.register(UINib(nibName: reuseIdentifier, bundle: Bundle.main), forCellReuseIdentifier: reuseIdentifier)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ConversationCell else { return UITableViewCell() }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 25))
        view.backgroundColor = UIColor.red
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: tableView.bounds.width - 30, height: 25))
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.black
        if section == 0 {
            label.text = "Online"
        } else {
            label.text = "History"
        }
        view.addSubview(label)
        return view
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toProfile", sender: nil)
    }

}
