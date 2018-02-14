//
//  addFriendsViewController.swift
//  Diner 2.0
//
//  Created by Seth Kujawa on 11/3/17.
//  Copyright © 2017 Seth Kujawa. All rights reserved.
//

import UIKit
import Firebase

class addFriendsViewController: UIViewController {
    
    var friends: [String]?
    
    let label: UILabel = {
        let l = UILabel();
        l.translatesAutoresizingMaskIntoConstraints = false;
        l.text = "Enter your friend's email:";
        return l;
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "friend@email.com"
        tf.translatesAutoresizingMaskIntoConstraints = false;
        return tf;
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
    
    lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Add", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240);
        addSubviews()
        setConstraints()
        getFriends()
    }
    
    func addSubviews() {
        view.addSubview(label);
        view.addSubview(textField)
        view.addSubview(backButton);
        view.addSubview(addButton);
    }
    
    func setConstraints() {
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true;
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        backButton.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
        label.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 50).isActive = true;
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50).isActive = true;
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true;
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
        addButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50).isActive = true;
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        addButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        addButton.widthAnchor.constraint(equalToConstant: 300).isActive = true;

    }

    
    @objc func handleBack() {
        let id = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(id!).child("friends").setValue(friends!);
        dismiss(animated: true, completion: nil);
    }
    
    @objc func handleAdd() {
        if(textField.text != ""){
            if (friends![0] == ""){
                friends = [textField.text!]
            } else {
                friends = friends! + [textField.text!]
            }
            handleBack()
        }
        
        
    }
    
    
    func getFriends(){
        let id = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(id!).child("friends").observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as! [String]
            self.friends = value;
        })
    }
    

}
