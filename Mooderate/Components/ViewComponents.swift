//
//  ViewComponents.swift
//  Mooderate
//
//  Created by Didami on 05/06/23.
//

import UIKit

// MARK: - Main Button
class MainButton: UIButton {
    
    var title: String? {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    var iconName = ""
    var inverted: Bool
    var rounded: Bool
    
    override var isSelected: Bool {
        didSet {
            self.setImage(UIImage(named: isSelected ? "\(iconName).fill" : iconName)?.resizedToIcon(), for: .normal)
        }
    }
    
    required init(title: String? = nil, iconName: String = "", color: UIColor = .jewel, bgColor: UIColor = .background, inverted: Bool = false, rounded: Bool = false, popIn: Bool = true) {
        self.title = title
        self.iconName = iconName
        self.inverted = inverted
        self.rounded = rounded
        super.init(frame: .zero)
        
        if iconName != "" { self.setImage(UIImage(named: iconName)?.resizedToIcon(), for: .normal) }
        self.tintColor = inverted ? bgColor : color
        
        if title != nil { self.setTitle(title, for: .normal) }
        self.titleLabel?.font = .mainFont(ofSize: 18, weight: .regular)
        self.setTitleColor(inverted ? bgColor : color, for: .normal)
        
        self.backgroundColor = inverted ? color : bgColor
        
        self.contentVerticalAlignment = .center
        self.contentHorizontalAlignment = .center
        
        self.imageView?.contentMode = .scaleAspectFit
        
        if inverted {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.white.cgColor
        }
        
        if popIn {
            self.addTarget(self, action: #selector(hanldePopIn), for: .touchUpInside)
        }
    }
    
    @objc private func hanldePopIn() {
        popIn(impact: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if rounded { self.circleView() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
