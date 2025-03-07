//
//  DetailsVC.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 28.04.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var passedData = (title: "Name", img: #imageLiteral(resourceName: "restaurant1"), price: 0, text: "Text", places: 0, availablePlaces: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = secondaryColor
        
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
        imgView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive=true
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive=true
        imgView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive=true
        imgView.heightAnchor.constraint(equalToConstant: 200).isActive=true
        imgView.image = passedData.img
        
        containerView.addSubview(lblTitle)
        lblTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15).isActive=true
        lblTitle.topAnchor.constraint(equalTo: imgView.bottomAnchor).isActive=true
        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 50).isActive=true
        lblTitle.text = "\(passedData.title) street"
        
        containerView.addSubview(lblPrice)
        lblPrice.leftAnchor.constraint(equalTo: lblTitle.leftAnchor, constant: 110).isActive=true
        lblPrice.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 80).isActive=true
        lblPrice.rightAnchor.constraint(equalTo: lblTitle.rightAnchor, constant: -110).isActive=true
        lblPrice.heightAnchor.constraint(equalToConstant: 50).isActive=true
        lblPrice.text = "₴\(passedData.price)"
        
        containerView.addSubview(lblDescription)
        lblDescription.leftAnchor.constraint(equalTo: lblTitle.leftAnchor).isActive=true
        lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 10).isActive=true
        lblDescription.rightAnchor.constraint(equalTo: lblTitle.rightAnchor).isActive=true
        lblDescription.text = """
        \(passedData.text)
        
        Amount of places for cars: \(passedData.places)
        
        Free places right now: \(passedData.availablePlaces)
        """
        
        containerView.addSubview(btnBookPlace)
        btnBookPlace.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30).isActive=true
        btnBookPlace.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20).isActive=true
        btnBookPlace.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive=true
        btnBookPlace.heightAnchor.constraint(equalToConstant: 50).isActive=true
        btnBookPlace.setTitle("Book parking place", for: .normal)
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
        v.image = #imageLiteral(resourceName: "restaurant1")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds=true
        v.translatesAutoresizingMaskIntoConstraints=false
        v.backgroundColor = UIColor.gray
        return v
    }()
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font=UIFont(name: "Futura-CondensedExtraBold", size: 22)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblPrice: UILabel = {
        let lbl=UILabel()
        lbl.text="$12"
        lbl.font=UIFont(name: "Futura-CondensedMedium", size: 26)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = secondaryColor.withAlphaComponent(0.55)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let lblDescription: UILabel = {
        let lbl=UILabel()
        lbl.text = "Description"
        lbl.numberOfLines = 0
        lbl.font=UIFont(name: "Futura-Medium", size: 20)
        lbl.textColor = UIColor.lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let btnBookPlace: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(white: 1, alpha: 0.2)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds = true
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Futura-CondensedMedium", size: 22)
//        btn.addTarget(self, action: #selector(btnActionLogOut), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
}
