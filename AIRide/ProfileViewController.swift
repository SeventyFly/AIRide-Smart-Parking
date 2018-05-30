//
//  ProfileViewController.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 17.05.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    var passedData = (username: "Name", email: "", balance: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)

        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(myScrollView)
        myScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        myScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        myScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        myScrollView.contentSize.height = 800
        
        myScrollView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor).isActive=true
        containerView.topAnchor.constraint(equalTo: myScrollView.topAnchor).isActive=true
        containerView.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive=true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        
        containerView.addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 80).isActive=true
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 20).isActive=true
        imgView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -80).isActive=true
        
        containerView.addSubview(lblUsername)
        lblUsername.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 65).isActive=true
        lblUsername.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 5).isActive=true
        lblUsername.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -65).isActive=true
        lblUsername.heightAnchor.constraint(equalToConstant: 40).isActive=true
        lblUsername.text = "Hello, \(passedData.username)!"

        containerView.addSubview(lblBalance)
        lblBalance.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive=true
        lblBalance.topAnchor.constraint(equalTo: lblUsername.bottomAnchor, constant: 15).isActive=true
        lblBalance.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive=true
        lblBalance.heightAnchor.constraint(equalToConstant: 50).isActive=true
        lblBalance.text = " Current balance: \(passedData.balance) UAH"
        
        containerView.addSubview(lblEmail)
        lblEmail.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive=true
        lblEmail.topAnchor.constraint(equalTo: lblBalance.bottomAnchor, constant: 15).isActive=true
        lblEmail.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive=true
        lblEmail.heightAnchor.constraint(equalToConstant: 50).isActive=true
        lblEmail.text = " Your email: \(passedData.email)"
        
        containerView.addSubview(btnChangeEmail)
        btnChangeEmail.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -90).isActive=true
        btnChangeEmail.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive=true
        btnChangeEmail.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -190).isActive=true
        btnChangeEmail.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnChangeEmail.setTitle("Change email", for: .normal)
        
        containerView.addSubview(btnChangePassword)
        btnChangePassword.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -90).isActive=true
        btnChangePassword.leftAnchor.constraint(equalTo: btnChangeEmail.rightAnchor, constant: 10).isActive=true
        btnChangePassword.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive=true
        btnChangePassword.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnChangePassword.setTitle("Change password", for: .normal)
        
        containerView.addSubview(btnLogOut)
        btnLogOut.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30).isActive=true
        btnLogOut.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive=true
        btnLogOut.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive=true
        btnLogOut.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnLogOut.setTitle("Log Out from \(passedData.username)", for: .normal)
    }
    
    let myScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.showsVerticalScrollIndicator=false
        scrollView.showsHorizontalScrollIndicator=false
        return scrollView
    }()
    
    let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let imgView: UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "Icon-180")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let lblUsername: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.backgroundColor = UIColor(white: 1, alpha: 0.2)
        lbl.font = UIFont(name: "Futura-CondensedExtraBold", size: 22)
        lbl.clipsToBounds = true
        lbl.tintColor = UIColor.darkGray
        lbl.layer.cornerRadius = 12
        lbl.textAlignment = .center
        lbl.textColor = UIColor(white: 1, alpha: 0.85)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblBalance: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.backgroundColor = UIColor(white: 1, alpha: 0.2)
        lbl.font = UIFont(name: "Futura-CondensedMedium", size: 23)
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.tintColor = UIColor.darkGray
        lbl.layer.cornerRadius = 10
        lbl.textColor = UIColor(white: 1, alpha: 0.85)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblEmail: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.backgroundColor = UIColor(white: 1, alpha: 0.2)
        lbl.font = UIFont(name: "Futura-CondensedMedium", size: 23)
        lbl.clipsToBounds = true
        lbl.textAlignment = .center
        lbl.tintColor = UIColor.darkGray
        lbl.layer.cornerRadius = 10
        lbl.textColor = UIColor(white: 1, alpha: 0.85)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    @objc func btnActionLogOut() {
        handleLogout((Any).self)
    }
    
    let btnChangePassword: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 1, alpha: 0.2)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Futura-CondensedMedium", size: 23)
//        btn.addTarget(self, action: #selector(btnActionLogOut), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let btnChangeEmail: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 1, alpha: 0.2)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Futura-CondensedMedium", size: 23)
//        btn.addTarget(self, action: #selector(btnActionLogOut), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let btnLogOut: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 1, alpha: 0.2)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Futura-CondensedExtraBold", size: 19)
        btn.addTarget(self, action: #selector(btnActionLogOut), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func handleLogout(_ sender:Any) {
        try! Auth.auth().signOut()
    }
}
