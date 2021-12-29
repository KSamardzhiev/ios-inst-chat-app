//
//  ChatViewController.swift
//  InstChat
//
//  Created by Kostadin Samardzhiev on 28.12.21.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var messages: [Message] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.appName
        navigationItem.hidesBackButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Constants.messageCellNib, bundle: nil), forCellReuseIdentifier: Constants.reusableCell)
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(Constants.FStore.messagesCollection)
            .order(by: Constants.FStore.messageDateKey)
            .addSnapshotListener { qSnapshot, error in
            if let e = error {
                print("Unable to fetch messages data: \(e)")
            } else {
                self.messages = []
                if let documents = qSnapshot?.documents {
                    for doc in documents {
                        if let mSender = doc[Constants.FStore.messageSenderKey] as? String, let mBody = doc[Constants.FStore.messageBodyKey] as? String {
                            self.messages.append(Message(sender: mSender, body: mBody))
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(Constants.FStore.messagesCollection).addDocument(data: [
                Constants.FStore.messageSenderKey: messageSender,
                Constants.FStore.messageBodyKey: messageBody,
                Constants.FStore.messageDateKey: Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print("Unable to save data to Firestore: \(e)")
                } else {
                    print("Successfully saved data")
                    self.messageTextField.text = ""
                }
            }
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - UITableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableCell) as! MessageCell
        cell.messageLabel.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            
            cell.messageBubble.backgroundColor = UIColor(named: Constants.Color.user2ColorSet)
            cell.messageLabel.textColor = UIColor(named: Constants.Color.user1ColorSet)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            
            cell.messageBubble.backgroundColor = UIColor(named: Constants.Color.user1ColorSet)
            cell.messageLabel.textColor = UIColor(named: Constants.Color.user2ColorSet)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

//MARK: - UITableViewDelegate

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row \(indexPath.row) selected")
    }
}
