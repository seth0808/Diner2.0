//
//  ViewController.swift
//  Diner 2.0
//
//  Created by Seth Kujawa on 11/1/17.
//  Copyright © 2017 Seth Kujawa. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    var d: NSDictionary?
    
    lazy var hostButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 240, g: 110, b: 110)
        button.setTitle("Host a Table", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleHost), for: .touchUpInside)
        
        return button
    }()
    
    lazy var findButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 240, g: 110, b: 110)
        button.setTitle("Find a Table", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleFind), for: .touchUpInside)
        
        return button
    }()
    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 240, g: 110, b: 110)
        button.setTitle("logout", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        
        return button
    }()
    
    let friendsLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false;
        v.isUserInteractionEnabled = true;
        v.text = "Friends";
        v.textAlignment = .center;
        v.textColor = UIColor.black;
        return v;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let t = UITapGestureRecognizer(target: self, action: #selector(handleFriends))
        friendsLabel.addGestureRecognizer(t);
        
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240);
        checkIfUserIsLoggedIn()
        
        addSubviews()
        setupConstraints()
        
        
    }
    
    @objc private func handleFriends() {
        let friendsVC = FriendsViewController();
        present(friendsVC, animated: true, completion: nil);
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true);
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
        }
    }
    private func addSubviews() {
        view.addSubview(logoutButton)
        view.addSubview(hostButton);
        view.addSubview(findButton);
        view.addSubview(friendsLabel);
        
    }
    private func setupConstraints() {
        logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true;
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        logoutButton.heightAnchor.constraint(equalToConstant: 35).isActive = true;
        logoutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true;
        
        hostButton.topAnchor.constraint(equalTo: logoutButton.bottomAnchor, constant: 100).isActive = true;
        hostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        hostButton.heightAnchor.constraint(equalToConstant: 200).isActive = true;
        hostButton.widthAnchor.constraint(equalToConstant: 350).isActive = true;
        
        findButton.topAnchor.constraint(equalTo: hostButton.bottomAnchor, constant: 30).isActive = true;
        findButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        findButton.heightAnchor.constraint(equalToConstant: 200).isActive = true;
        findButton.widthAnchor.constraint(equalToConstant: 350).isActive = true;
        
        friendsLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true;
        friendsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        friendsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        friendsLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
      
    }
    /*
    @objc private func handleGet() {
        if (self.d == nil){
        Database.database().reference().observe(.value, with: { (snapshot) in
            
            let dictionary = snapshot.value as! NSDictionary
            self.d = dictionary;
            
        })
        } else {
            let userDictionary = d!.object(forKey: "users") as! NSDictionary
            
            print(userDictionary.allKeys);
        }
    }
    
    @objc private func handleSet() {
        let id = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(id!).child("isHosting").setValue(true)
    }
 */
    
    @objc func handleFind() {
       let FindVC = FindViewController();
       present(FindVC, animated: true, completion: nil);
        
    }
    @objc func handleHost() {
       let HostVC = HostViewController();
       present(HostVC, animated: true, completion: nil);
    }
    
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            
        } catch let logoutError {
            print(logoutError)
            
        }
        let loginVC = loginViewController()
        present(loginVC, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
}

