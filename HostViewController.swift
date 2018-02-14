//
//  HostViewController.swift
//  Diner 2.0
//
//  Created by Seth Kujawa on 11/2/17.
//  Copyright © 2017 Seth Kujawa. All rights reserved.
//

import UIKit
import Firebase

class HostViewController: UIViewController {
    
    var isHosting: Bool?
    
    var currentLocation: Any?
    
    lazy var hostButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Host", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleToggleHost), for: .touchUpInside)
        
        return button
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
    
    let dot: UIImageView = {
        let i = UIImageView();
        i.image = UIImage(named: "pointer");
        i.contentScaleFactor = 20;
        i.translatesAutoresizingMaskIntoConstraints = false;
        
        return i;
    }()
    
    let image: UIImageView = {
        let i = UIImageView();
        i.image = UIImage(named: "Diner1");
        i.translatesAutoresizingMaskIntoConstraints = false;
        
        return i;
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 240, g: 240, b: 240);
        setHostButton(completion: setHostButtonHelper);
        setInitialLocation(completion: setInitialLocationHelper);
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(image);
        view.addSubview(backButton);
        view.addSubview(hostButton);
    }
    private func setConstraints() {
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true;
        image.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true;
        image.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true;
        image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true;
        
        hostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        hostButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true;
        hostButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        hostButton.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
        backButton.topAnchor.constraint(equalTo: hostButton.bottomAnchor, constant: 10).isActive = true;
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
        backButton.widthAnchor.constraint(equalToConstant: 300).isActive = true;
        
    }
    func setHostButtonHelper() {
        if(self.isHosting!){
            hostButton.setTitle("Currently Hosting", for: .normal)
        } else {
            hostButton.setTitle("Currently Not Hosting", for: .normal)
        }
    }
    
    func setInitialLocationHelper() {
        var c = currentLocation as! [CGFloat]
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
    
    private func setHostButton(completion: @escaping () -> ()){
            let id = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(id!).child("isHosting").observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as! Bool
                self.isHosting = value;
                completion();
        })
    }
    
    private func setInitialLocation(completion: @escaping () -> ()) {
        let id = Auth.auth().currentUser?.uid
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("users").child(id!).child("location").observe(.value, with: { (snapshot) in
            
            let value = snapshot.value as! [CGFloat]
            self.currentLocation = value;
            completion();
        })
    }
    
    @objc private func handleToggleHost() {
        if (self.isHosting!){
            let id = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(id!).child("isHosting").setValue(false);
            ref.child("users").child(id!).child("location").setValue([-1, -1]);
        } else {
            let id = Auth.auth().currentUser?.uid
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child("users").child(id!).child("isHosting").setValue(true);
            ref.child("users").child(id!).child("location").setValue(currentLocation);
        }
        setHostButton(completion: setHostButtonHelper);
        setInitialLocation(completion: setInitialLocationHelper);
    }
    @objc private func handleBack() {
        dismiss(animated: true, completion: nil);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first as! UITouch
        let location = touch.location(in: self.view);
        
        dot.removeFromSuperview();
        view.addSubview(dot);
        dot.topAnchor.constraint(equalTo: view.topAnchor, constant: location.y - 40).isActive = true;
        dot.leftAnchor.constraint(equalTo: view.leftAnchor, constant: location.x - 20).isActive = true;
        dot.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        dot.widthAnchor.constraint(equalToConstant: 40).isActive = true;
        
        currentLocation = [location.x, location.y];
        
    }
    
    


}
