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
    
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Блокировка портретного режима
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .portrait
        }
        
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
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
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return onlineList.count
        } else {
            return offlineList.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ConversationCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            cell.configure(with: onlineList[indexPath.row])
            let gradient = GradientView()
            gradient.configure(startColor: .systemYellow, endColor: .white, startLocation: 0, endLocation: 1, startPoint: CGPoint(x: -0.5, y: 0), endPoint: CGPoint(x: 1, y: 0))
            cell.backgroundView = gradient
        } else {
            cell.configure(with: offlineList[indexPath.row])
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
            label.text = "Online"
        } else {
            label.text = "History"
        }
        view.addSubview(label)
        return view
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toConversation", sender: nil)
    }
    
    // MARK: - TestData
    
    let data = [
        ConversationCellModel(name: "Юлия Абрамова", message: "Сдам квартиру, отдам билеты на самолёт, посажу в такси до аэропорта, а сама домой", date: Date() - (60*60*24), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Карина Александровна", message: "Я конечно конфетки быстро уминаю, но сейчас не могу их быстро скушать, потому что я их не заслужила (а вообще их очень много)", date: Date() - (60*60*7), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Надя Байдак", message: "Идейные соображения высшего порядка, а также начало повседневной работы по формированию позиции позволяет оценить значение модели развития", date: Date() - (60*60*24), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Ксюша Бегич", message: "Повседневная практика показывает, что укрепление и развитие структуры обеспечивает широкому кругу (специалистов) участие в формировании дальнейших направлений развития", date: Date() - (60*16*6), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Геннадий Букин", message: "Равным образом рамки и место обучения кадров влечет за собой процесс внедрения и модернизации системы обучения кадров, соответствует насущным потребностям.", date: Date() - (60*48*10), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Артем Вавилов", message: "Таким образом новая модель организационной деятельности способствует подготовки и реализации систем массового участия.", date: Date() - (60*60*24), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Дима Волобоев", message: "Товарищи! постоянное информационно-пропагандистское обеспечение нашей деятельности позволяет выполнять важные задания по разработке модели развития", date: Date() - (60*60*24), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Ксения Гержан", message: "С другой стороны укрепление и развитие структуры обеспечивает участие в формировании систем массового участия.", date: Date() - (60*16*5), isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Екатерина Графова", message: "Привет", date: Date() - (60*29*6), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Анна Дзюба", message: "Как дела?", date: Date() - (60*60*24), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Александр Евграфов", message: "Что делаешь?", date: Date() - (60*51*6), isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Анастасия Иванова", message: nil, date: nil, isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Павел Калашников", message: "Я на месте", date: Date() - (60*39*19), isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Катя Каткова", message: "Ты где?", date: Date() - (60*2*8), isOnline: true, hasUnreadMessages: true),
        ConversationCellModel(name: "Виктория Козинская", message: nil, date: nil, isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Андрей Королев", message: nil, date: nil, isOnline: false, hasUnreadMessages: true),
        ConversationCellModel(name: "Полина Ли", message: nil, date: nil, isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Владислав Медведев", message: nil, date: nil, isOnline: true, hasUnreadMessages: false),
        ConversationCellModel(name: "Иван Парфенов", message: nil, date: nil, isOnline: false, hasUnreadMessages: false),
        ConversationCellModel(name: "Рустам Какабаевич", message: "Слыш где мои деньги?", date: Date() - (60*16*19), isOnline: false, hasUnreadMessages: true)
    ]
    
    var onlineList: Array<ConversationCellModel> = []
    var offlineList: Array<ConversationCellModel> = []


}
