//
//  ChannelViewController.swift
//  Parrot
//
//  Created by Const. on 01.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController, IMessagesDelegate {
    
    fileprivate let reuseIdentifier = "MessageCell"
    
    // MARK: - Private
    
    private var name: String
    private var model: IMessagesVCModel
    private let presentationAssembly: IPresentationAssembly
    
    private var groupedMessages: [[MessageModel]] = []
    
    
    // MARK: - UI
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    let messageInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.attributedPlaceholder = NSAttributedString(string: "Enter message...",
                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.tintColor = .systemYellow
        return textField
    }()
    
    let sendButton: CustomButton = {
        let button = CustomButton()
        button.changeBackroundColor(.systemYellow)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(sendMessage(sender:)), for: .touchUpInside)
        return button
    }()
    
    var messageViewBottomConstraint: NSLayoutConstraint?
    
    // MARK: - VC Lifecycle
    
    init(model: IMessagesVCModel, presentationAssembly: IPresentationAssembly, name: String) {
        self.model = model
        self.presentationAssembly = presentationAssembly
        self.name = name
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.delegate = self
        tableView.separatorStyle = .none
        
        fillView()
        
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGesture)
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        navigationItem.title = name
        model.getMessages()
        animateSendButton(with: .lightGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    // MARK: - fill View
    
    private func fillView() {
        view.addSubview(tableView)
        view.addSubview(messageInputView)
        
        // MARK: - messageInputView
        messageInputView.translatesAutoresizingMaskIntoConstraints = false
        
        messageViewBottomConstraint = messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        messageViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            messageInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageInputView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // MARK: - colorView
        let colorView = UIView()
        colorView.backgroundColor = .darkGray

        view.addSubview(colorView)

        colorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            colorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            colorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            colorView.topAnchor.constraint(equalTo: messageInputView.bottomAnchor)
        ])
        
        
        // MARK: - TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // MARK: - inputTextField
        messageInputView.addSubview(inputTextField)
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: messageInputView.topAnchor, constant: 10),
            inputTextField.bottomAnchor.constraint(equalTo: messageInputView.bottomAnchor, constant: -10),
            inputTextField.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 10)
        ])
        
        // MARK: - sendButton
        messageInputView.addSubview(sendButton)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: messageInputView.topAnchor, constant: 10),
            sendButton.bottomAnchor.constraint(equalTo: messageInputView.bottomAnchor, constant: -10),
            sendButton.leadingAnchor.constraint(equalTo: inputTextField.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -10),
            sendButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/5)
        ])
    
        
    }
    
    // MARK: - Send Message
    
    @objc func sendMessage(sender: UIButton) {
        if let text = inputTextField.text {
            if text.replacingOccurrences(of: " ", with: "") != "" {
                let trueText = text.trimmingCharacters(in: .whitespaces)
                
                model.sendMessage(message: trueText)
            }
        }
        
        inputTextField.text = ""
        hideKeyboard()
        
    }
    
    // MARK: - Send Button animation
    
    private var sendButtonAnimationIsFinished = true
    
    private func animateSendButton(with color: UIColor) {
        
        UIView.animate(withDuration: 1, animations: {
            self.sendButton.changeBackroundColor(color)
        })
        if sendButtonAnimationIsFinished {
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                self.sendButton.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                self.sendButtonAnimationIsFinished = false
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: [.allowUserInteraction], animations: {
                    self.sendButton.transform = CGAffineTransform.identity
                })
                self.sendButtonAnimationIsFinished = true
            })
        }
        
    }
    
    // MARK: keyboard notification
    @objc func keyboardWasShown(notification: Notification) {
        
        if let info = notification.userInfo as NSDictionary? {
            let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue
            
            messageViewBottomConstraint?.isActive = false
            messageViewBottomConstraint = messageInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -kbSize.height)
            messageViewBottomConstraint?.isActive = true
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: { [weak self] in
                self?.view.layoutIfNeeded()
            }, completion: { [weak self] (flag) in
                if flag {
                    self?.scrollToBottom()
                }
            })

        }

    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        messageViewBottomConstraint?.isActive = false
        messageViewBottomConstraint = messageInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        messageViewBottomConstraint?.isActive = true
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Scroll and update
    
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
    
    
    // MARK: - IMessagesDelegate
    
    func setup(with newMessages: [MessageModel]) {
        self.groupedMessages = model.groupMessages(messages: newMessages)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            if let firstScroll = self?.firstScroll, firstScroll {
                self?.scrollToBottom()
                self?.firstScroll = false
            }
            if self?.groupedMessages.last?.last?.senderID == self?.model.getSenderID() {
                self?.scrollToBottom()
            }
        }
    }

}



// MARK: - Table view data source
extension MessagesViewController : UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedMessages.count
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedMessages[section].count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? MessageCell else {return UITableViewCell()}

        let isIncoming: Bool
        
        if groupedMessages[indexPath.section][indexPath.row].senderID == model.getSenderID() {
            isIncoming = false
        } else {
            isIncoming = true
        }
        let currMessage = groupedMessages[indexPath.section][indexPath.row]
        
        let cellModel = MessageCellModel(text: currMessage.content, date: currMessage.created, senderName: currMessage.senderName, isIncoming: isIncoming)
        cell.configure(with: cellModel)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = HeaderLabel()
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

// MARK: - Text field Delegate
extension MessagesViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if (textField.text! != "" && sendButton.backgroundColor == UIColor.lightGray) {
            animateSendButton(with: .systemYellow)
        } else if (textField.text! == "") {
            animateSendButton(with: .lightGray)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
