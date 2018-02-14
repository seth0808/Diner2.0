//
//  FriendsViewController.swift
//  Diner 2.0
//
//  Created by Seth Kujawa on 11/3/17.
//  Copyright © 2017 Seth Kujawa. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friends: [String]?
    
    let friendsTable: UITableView = {
        let ft = UITableView();
        ft.translatesAutoresizingMaskIntoConstraints = false;
        return ft;
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
    
    lazy var addFriendsButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Add Friends", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleAddFriends), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getFriends(completion: getFriendsHelper);
        
        friends = ["No Internet Connection :("];
        
        friendsTable.dataSource = self;
        friendsTable.delegate = self;
        
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240);
        addSubviews();
        setConstraints();
        
    }
    func addSubviews(){
        view.addSubview(friendsTable)
        view.addSubview(backButton)
        view.addSubview(addFriendsButton);
    }
    
    func setConstraints() {
        friendsTable.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50).isActive = true;
        friendsTable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        friendsTable.heightAnchor.constraint(equalToConstant: 500).isActive = true;
        friendsTable.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true;
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        backButton.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
        addFriendsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true;
        addFriendsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        addFriendsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        addFriendsButton.widthAnchor.constraint(equalToConstant: 300).isActive = true;
    
    }

    @objc func handleAddFriends() {
        if (friends?.isEmpty)!{
            let id = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(id!).child("friends").setValue([""]);
        } else {
            let id = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(id!).child("friends").setValue(friends!);
        }
        
        let addfriendsVC = addFriendsViewController();
        present(addfriendsVC, animated: true, completion: nil)
    }
    
    
    func getFriendsHelper() {
        friendsTable.reloadData()
    }
    
    func getFriends(completion: @escaping () -> ()){
        let id = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(id!).child("friends").observe(.value, with: { (snapshot) in
            
           let value = snapshot.value as! [String]
           self.friends = value;
            completion();
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let first = 0
        let last = friends!.count - 1
        var newFriends: [String] = []
        for index in first...last {
            if (index != indexPath.row){
                newFriends.append(friends![index])
            }
        }
        friends = newFriends;
        friendsTable.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends!.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell();
        cell.textLabel?.text = friends![indexPath.row];
        return cell;
    }
    
    @objc func handleBack() {
        if (friends?.isEmpty)!{
            let id = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(id!).child("friends").setValue([""]);
        } else {
            let id = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(id!).child("friends").setValue(friends!);
        }
        dismiss(animated: true, completion: nil);
    }

    

}
