//
//  CustomMarkerView.swift
//  AIRide
//
//  Created by Oleh Komarnitsky on 28.04.2018.
//  Copyright © 2018 SeventyFly. All rights reserved.
//

import Foundation
import UIKit

class ParkingMarkerView: UIView {
    var availablePlaces: Int
    var borderColor: UIColor!
    
    init(frame: CGRect, availablePlaces: Int, borderColor: UIColor, tag: Int) {
        self.availablePlaces = availablePlaces
        super.init(frame: frame)
        self.borderColor = borderColor
        self.backgroundColor = UIColor.clear
        self.tag = tag
        setupViews()
    }
    
    func setupViews() {
        let availablePlacesView = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        availablePlacesView.text = "\(availablePlaces)"
        availablePlacesView.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 22)
        availablePlacesView.textColor = UIColor(white: 1, alpha: 1)
        availablePlacesView.textAlignment = .center
        if availablePlaces == 0 {
            availablePlacesView.backgroundColor = UIColor(patternImage: UIImage(named:"busymarker")!).withAlphaComponent(1)
        } else {
            availablePlacesView.backgroundColor = UIColor(patternImage: UIImage(named:"freemarker")!).withAlphaComponent(1)
        }
        
        availablePlacesView.clipsToBounds = true

        self.addSubview(availablePlacesView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
