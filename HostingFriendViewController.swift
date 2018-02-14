//
//  HostingFriendViewController.swift
//  Diner 2.0
//
//  Created by Seth Kujawa on 11/5/17.
//  Copyright © 2017 Seth Kujawa. All rights reserved.
//

import UIKit
import Firebase

class HostingFriendViewController: UIViewController {
    
    var location: [CGFloat]?
    
    var previousVC: FindViewController?
    
    let image: UIImageView = {
        let i = UIImageView();
        i.translatesAutoresizingMaskIntoConstraints = false;
        i.image = UIImage(named: "Diner1");
        return i;
    }()
    
    let dot: UIImageView = {
        let i = UIImageView();
        i.image = UIImage(named: "pointer");
        i.contentScaleFactor = 20;
        i.translatesAutoresizingMaskIntoConstraints = false;
        
        return i;
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
        
        getLocation(completion: getLocationHelper)
        
        addSubviews();
        setConstraints()
    }
    
    func addSubviews() {
        view.addSubview(image)
        view.addSubview(backButton)
    }
    func setConstraints() {
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true;
        image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true;
        image.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true;
        image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true;
        
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true;
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        backButton.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
    }
    
    @objc func handleBack() {
        dismiss(animated: true, completion: nil);
    }
    
    func getLocationHelper() {
        view.addSubview(dot)
        var c = location as! [CGFloat]
        if (c[0] != -1){
            dot.removeFromSuperview();
            view.addSubview(dot);
            dot.topAnchor.constraint(equalTo: view.topAnchor, constant: c[1] - 40).isActive = true;
            dot.leftAnchor.constraint(equalTo: view.leftAnchor, constant: c[0] - 20).isActive = true;
            dot.heightAnchor.constraint(equalToConstant: 40).isActive = true;
            dot.widthAnchor.constraint(equalToConstant: 40).isActive = true;
        } else {
            dot.removeFromSuperview();
            view.addSubview(dot);
            dot.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
            dot.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
            dot.heightAnchor.constraint(equalToConstant: 40).isActive = true;
            dot.widthAnchor.constraint(equalToConstant: 40).isActive = true;
        }
    }
    
    func getLocation(completion: @escaping() -> ()){
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").observe(.value, with: { (snapshot) in
            
            let usersDict = snapshot.value as! NSDictionary
            for userID in usersDict{
                let userIDDict = userID.value as! NSDictionary
                if (self.previousVC?.friendSelected == userIDDict.object(forKey: "email") as? String) {
                    self.location = userIDDict.object(forKey: "location") as? [CGFloat]
                }
            }
            completion();
            
        })
    }

}
