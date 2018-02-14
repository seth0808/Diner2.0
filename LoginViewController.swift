//
//  LoginViewController.swift
//  Diner 2.0
//
//  Created by Seth Kujawa on 11/1/17.
//  Copyright © 2017 Seth Kujawa. All rights reserved.
//

import UIKit
import Firebase

class loginViewController: UIViewController {
    
    let segmentedController: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.insertSegment(withTitle: "Login", at: 0, animated: false);
        sc.insertSegment(withTitle: "Register", at: 1, animated: false);
        sc.isUserInteractionEnabled = true;
        sc.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
        sc.selectedSegmentIndex = 0;
        return sc
    }()
    
    let nameText: UITextField = {
        let nt = UITextField()
        nt.translatesAutoresizingMaskIntoConstraints = false
        nt.placeholder = "name"
        return nt
    }()
    let emailText: UITextField = {
        let nt = UITextField()
        nt.translatesAutoresizingMaskIntoConstraints = false
        nt.placeholder = "email"
        return nt
    }()
    let passText: UITextField = {
        let nt = UITextField()
        nt.translatesAutoresizingMaskIntoConstraints = false
        nt.placeholder = "password"
        return nt
    }()
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Login", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginOrRegister), for: .touchUpInside)
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240)
        addSubviews()
        setupConstraints()
    }
    
    @objc private func handleLoginOrRegister() {
        if (segmentedController.selectedSegmentIndex == 0){
            handleLogin();
        } else {
            handleRegister();
        }
    }
    
    @objc private func handleSwitch() {
        let title = segmentedController.titleForSegment(at: segmentedController.selectedSegmentIndex)
        loginButton.setTitle(title, for: .normal)
        if (segmentedController.selectedSegmentIndex == 0){
            nameText.removeFromSuperview();
        } else {
            view.addSubview(nameText)
            
            nameText.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 25).isActive = true
            nameText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            nameText.widthAnchor.constraint(equalToConstant: 350).isActive = true
            nameText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        
    }
    
    
    
    private func addSubviews() {
        view.addSubview(emailText)
        view.addSubview(passText)
        view.addSubview(loginButton)
        view.addSubview(segmentedController)
    }
    private func setupConstraints() {
        segmentedController.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        segmentedController.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedController.widthAnchor.constraint(equalToConstant: 350).isActive = true
        segmentedController.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailText.topAnchor.constraint(equalTo: view.topAnchor, constant: 260).isActive = true
        emailText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailText.widthAnchor.constraint(equalToConstant: 350).isActive = true
        emailText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        passText.topAnchor.constraint(equalTo: emailText.bottomAnchor, constant: 0).isActive = true
        passText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passText.widthAnchor.constraint(equalToConstant: 350).isActive = true
        passText.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passText.bottomAnchor, constant: 10).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 350).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    @objc func handleRegister() {
        if let _ = emailText.text, let _ = passText.text, let _ = nameText.text{
            Auth.auth().createUser(withEmail: emailText.text!, password: passText.text!,
                                   completion: { (user: User?, error) in
                                    if error != nil {
                                        print("Error!!!  Password might not be long enough")
                                        return
                                    }
                                    guard (user?.uid) != nil else {
                                        return
                                    }
                                    let uid = user?.uid
                                    let values = ["name": self.nameText.text!, "email": self.emailText.text!]
                                    self.registerUserIntoDatabaseWithUID(uid: uid!, values: values as [String : AnyObject])
            })
        }
        
    }
    @objc func handleLogin() {
        guard let email = emailText.text, let password = passText.text else { return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print("There was an error")
                return
            }
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        //update database
        let ref = Database.database().reference(fromURL: "https://diner2-a023e.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print("THERE WAS AN ERROR")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        })
        
        let id = Auth.auth().currentUser?.uid
        var reference: DatabaseReference!
        reference = Database.database().reference()
        reference.child("users").child(id!).child("isHosting").setValue(false)
        let f = [""];
        reference.child("users").child(uid).child("friends").setValue(f);
        let l = [-1, -1];
        reference.child("users").child(uid).child("location").setValue(l);
    }
    
    
    
    
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}
