//
//  FindViewController.swift
//  Diner 2.0
//
//  Created by Seth Kujawa on 11/5/17.
//  Copyright © 2017 Seth Kujawa. All rights reserved.
//

import UIKit
import Firebase

class FindViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var friends: [String]?
    var friendsWhoAreHosting:[String]?
    var friendSelected: String?
    
    let table: UITableView = {
        let t = UITableView();
        t.translatesAutoresizingMaskIntoConstraints = false;
        return t;
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Back", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        table.delegate = self;
        table.dataSource = self;
        
        addSubviews()
        setConstraints()
        
        self.friendsWhoAreHosting = []
        getFriends();
        getFriendsWhoAreHosting(completion: getFriendsWhoAreHostingHelper);
        
    }
    
    func addSubviews() {
        view.addSubview(table)
        view.addSubview(backButton);
    }
    func setConstraints() {
        table.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50).isActive = true;
        table.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        table.heightAnchor.constraint(equalToConstant: 400).isActive = true;
        table.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true;
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        backButton.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        friendSelected = friendsWhoAreHosting?[indexPath.row]
        let hostingFriendVC = HostingFriendViewController();
        hostingFriendVC.previousVC = self
        present(hostingFriendVC, animated: true, completion: nil);
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell();
        cell.textLabel?.text = friendsWhoAreHosting?[indexPath.row]
        return cell;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (friendsWhoAreHosting?.count)!
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func getFriendsWhoAreHostingHelper() {
        table.reloadData()
    }
    
    func getFriendsWhoAreHosting(completion: @escaping() -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").observe(.value, with: { (snapshot) in

            let usersDict = snapshot.value as! NSDictionary
            for userID in usersDict{
                let userIDDict = userID.value as! NSDictionary
                for friend in self.friends! {
                    if (friend == userIDDict.object(forKey: "email") as! String && userIDDict.object(forKey: "isHosting") as! Bool) {
                        self.friendsWhoAreHosting!.append(friend)
                    }
                }
            }
            
            completion();
 
        })
 
    }

    func getFriends(){
        let id = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(id!).child("friends").observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as! [String]
            self.friends = value
        })
    }
   

}
