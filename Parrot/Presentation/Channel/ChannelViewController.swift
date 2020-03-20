//
//  ChannelViewController.swift
//  Parrot
//
//  Created by Const. on 01.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class ChannelViewController: UITableViewController {
    
    fileprivate let reuseIdentifier = "MessageCell"
    
    // MARK: - Private
    
    private var name: String!
    private var messageFlag: Bool!
    
    func setName(name: String?) {
        if let unrName = name {
            self.name = unrName
        } else {
            self.name = ""
        }
    }
    
    func setFlag(flag: Bool) {
        self.messageFlag = flag
    }
    

    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        navigationItem.title = name
        
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !messageFlag {
            return 0
        }
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else {return UITableViewCell()}

        
        cell.configure(with: data[indexPath.row])

        return cell
    }
    

    // MARK: - TestData
    
    var data = [
        MessageCellModel(text: "Привет", isIncoming: true),
        MessageCellModel(text: "А ты видел, что открылся новый океанариум?", isIncoming: true),
        MessageCellModel(text: "Что? Правда?", isIncoming: false),
        MessageCellModel(text: "Где?", isIncoming: false),
        MessageCellModel(text: "Да, его окрыли всего пару дней назад. Вроде на малой пионерской. Но это не точно, нужно посмотреть по карте", isIncoming: true),
        MessageCellModel(text: "Класс, это совсем рядом с моим домом", isIncoming: false),
        MessageCellModel(text: "Может сходим на выходных?", isIncoming: false),
        MessageCellModel(text: "К сожалению на этой неделе не могу. У меня болит живот. Давай как-нибудь на следующей неделе состыкуемся", isIncoming: true),
        MessageCellModel(text: "Ок, потом тогда разберемся", isIncoming: false)
    ]

}
