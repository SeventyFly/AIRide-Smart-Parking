//
//  RestaurantPreviewView.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 28.04.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import Foundation
import UIKit

class PreviewParkingViewController: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        setupViews()
    }
    
    func setData(title: String, img: UIImage, price: Int) {
        lblTitle.text = "Parking on \(title) street"
        imgView.image = img
        lblPrice.text = "\(price)₴/hour"
    }
    
    func setupViews() {
        addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        containerView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        containerView.addSubview(lblTitle)
        lblTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0).isActive=true
        lblTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive=true
        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 35).isActive=true

        addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        imgView.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive=true
        imgView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        imgView.heightAnchor.constraint(equalToConstant: self.frame.height - 55).isActive=true

        addSubview(lblPrice)
        lblPrice.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        lblPrice.centerYAnchor.constraint(equalTo: centerYAnchor).isActive=true
        lblPrice.widthAnchor.constraint(equalToConstant: 90).isActive=true
        lblPrice.heightAnchor.constraint(equalToConstant: 40).isActive=true
        
        addSubview(lblAnchor)
        lblAnchor.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 1).isActive=true
        lblAnchor.topAnchor.constraint(equalTo: imgView.bottomAnchor).isActive=true
        lblAnchor.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let imgView: UIImageView = {
        let v = UIImageView()
        v.alpha = 1
        v.image = #imageLiteral(resourceName: "restaurant1")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font = UIFont(name: "Futura-CondensedExtraBold", size: 15)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = secondaryColor
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let lblAnchor: UILabel = {
        let lbl = UILabel()
        lbl.text = "▾"
        lbl.font = UIFont.systemFont(ofSize: 32)
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.clear
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let lblPrice: UILabel = {
        let lbl=UILabel()
        lbl.text="$12"
        lbl.font=UIFont(name: "Futura-CondensedMedium", size: 17)
        lbl.textColor=UIColor.white
        lbl.backgroundColor = secondaryColor
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        lbl.clipsToBounds = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
