//
//  ChatViewController.swift
//  Chat
//
//  Created by Yusuf Bayindir on 2/7/24.
//

import UIKit
import Firebase
import UserNotifications

class ChatViewController: UIViewController  {
    
    


    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var stackViewTopEqualTableBottom20: NSLayoutConstraint!
    @IBOutlet weak var safeAreaBottomEqualStackViewBottom: NSLayoutConstraint!
    
    var keyboardHeight = CGFloat(0.0)
    var messages:[Message] = []
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var sendButtonLabel: UIButton!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var chatText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        chatText.delegate = self
        chatText.returnKeyType = .send
        
        title = Constants.title
        navigationItem.hidesBackButton = true
        
        mainView.backgroundColor = UIColor(hex: Constants.ColorsPattern.blackColor)
        navigationController?.navigationBar.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        
        sendButtonLabel.tintColor = UIColor(hex: Constants.ColorsPattern.orangeColor)
        
        table.register(UINib(nibName: Constants.cellName, bundle: nil), forCellReuseIdentifier: Constants.reusuableCell)
        
        loadMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
   
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NotificationCenter.default.removeObserver(self)
        }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func loadMessages() {
        do {
            let _ = db.collection("messages").order(by: "date").addSnapshotListener( { [self] querySnapshot, error in
                messages = []
                if error != nil {
                    print("There is a message upload error")
                }else{
                    if (querySnapshot?.documents) != nil{
                        for messageInQuery in querySnapshot!.documents {
                            self.messages.append(Message(sender: messageInQuery.data()["sender"] as? String ?? "\(String(describing: messageInQuery.data()["sender"]))", body: messageInQuery.data()["body"] as? String ?? "\(String(describing: messageInQuery.data()["body"]))"))
                            DispatchQueue.main.async {
                                self.table.reloadData()
                                let indexP = IndexPath(row: self.messages.count - 1, section: 0)
                                self.table.scrollToRow(at: indexP, at: .top, animated: true)
                                // Yeni bir yerel bildirim oluşturma
                                let content = UNMutableNotificationContent()
                                content.title = "New Message"
                                content.body = self.messages[self.messages.count - 1].body
                                content.sound = UNNotificationSound.default

                                // Tetikleyiciyi ayarlama, örneğin 5 saniye sonra
                                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

                                // İstek oluşturma
                                let request = UNNotificationRequest(identifier: "ID", content: content, trigger: trigger)

                                // Bildirim merkezine ekleme
                                UNUserNotificationCenter.current().add(request) { error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                }
                            }
                        }
                    }
                    
                }
            })
           
        }
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        sendMessages()
        chatText.text = ""
    }
    func sendMessages() {
        if let messageBody = chatText.text, let messageSender = Auth.auth().currentUser?.email{
            _ = Message(sender: messageSender, body: messageBody)
            do {
                _ = db.collection("messages").addDocument(data: ["body" : messageBody, "sender" : messageSender, "date" : Date().timeIntervalSince1970])
            }
        }
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}
extension ChatViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessages()
        chatText.text = ""
        return true
    }
}
extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: Constants.reusuableCell, for: indexPath) as! MessageCell
        
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            cell.cellLabel.textAlignment = NSTextAlignment.right
            cell.cellLabel.backgroundColor = UIColor(hex: Constants.ColorsPattern.grayColor)
        }else{
            cell.cellLabel.textAlignment = NSTextAlignment.left
            cell.cellLabel.backgroundColor = UIColor(hex: Constants.ColorsPattern.blueColor)
        }
        cell.cellLabel.text = messages[indexPath.row].body
        return cell
        
    }
    
    
}

extension ChatViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        
        UIView.animate(withDuration: 3) {
            self.safeAreaBottomEqualStackViewBottom.constant  =  self.keyboardHeight
            self.stackViewTopEqualTableBottom20.constant = -self.keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.safeAreaBottomEqualStackViewBottom.constant  =  20
            self.stackViewTopEqualTableBottom20.constant = 40
            self.view.layoutIfNeeded()
        }
    }
}
