//
//  ParentController.swift
//  Mooderate
//
//  Created by Didami on 05/06/23.
//

import UIKit

class ParentController: UIViewController {
    
    // MARK: - Front-End
    static let tabBarHeight = UIScreen.main.bounds.height / 8
    
    lazy var contentView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    let button1 = MainButton(iconName: "home", bgColor: .clear)
    let button2 = MainButton(iconName: "calendar", bgColor: .clear)
    
    lazy var tabBar: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .aquaForest
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 24
        container.addShadow(offset: .zero, color: .jewel, radius: 10, opacity: 0.5)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.backgroundColor = .clear
        stackView.layer.masksToBounds = true
        
        container.addSubview(stackView)
        stackView.pinToSuperview(with: 20)
        
        button1.isSelected = true
        
        button1.tag = 1
        button2.tag = 2
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        
        button1.addTarget(self, action: #selector(handleTabBarButton(_:)), for: .touchUpInside)
        button2.addTarget(self, action: #selector(handleTabBarButton(_:)), for: .touchUpInside)
        
        return container
    }()
    
    private func setupViews() {
        view.backgroundColor = .background
        navigationController?.navigationBar.isHidden = true
        
        // add subviews
        view.addSubview(contentView)
        view.addSubview(tabBar)
        
        // x, y, w, h
        contentView.pinToSuperview()
        
        tabBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.safeSpacing).isActive = true
        tabBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3/4).isActive = true
        tabBar.heightAnchor.constraint(equalToConstant: ParentController.tabBarHeight).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        displayCurrentTab(TabIndex.firstChild.rawValue)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let currentViewController = currentController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    // MARK: - Back-End
    enum TabIndex: Int {
        case firstChild = 0
        case secondChild = 1
    }
    
    var currentController: UIViewController?
    
    let homeController = HomeController()
    let calendarController = CalendarController()
    
    func displayCurrentTab(_ tabIndex: Int) {
        
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentController = vc
            
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        
        var vc: UIViewController?
        
        switch index {
        case TabIndex.firstChild.rawValue :
            homeController.parentController = self
            vc = homeController
        case TabIndex.secondChild.rawValue :
            calendarController.parentController = self
            vc = calendarController
        default:
            return nil
        }
        
        return vc
    }
    
    public func switchToTab(_ tabIndex: Int) {
        
        if viewControllerForSelectedSegmentIndex(tabIndex) == currentController {
            return
        }
        
        UIView.animate(withDuration: Constants.mainAnimationDuration / 2) {
            self.contentView.alpha = 0
        } completion: { [weak self] _ in
            
            self?.currentController!.view.removeFromSuperview()
            self?.currentController!.removeFromParent()
            
            self?.displayCurrentTab(tabIndex)
            
            UIView.animate(withDuration: Constants.mainAnimationDuration) {
                self?.contentView.alpha = 1
            }
        }
    }
    
    func setTabBarHidden(_ hidden: Bool) {
        
        UIView.animate(withDuration: 0.25) {
            self.tabBar.alpha = hidden ? 0 : 1
        } completion: { _ in
            self.tabBar.isUserInteractionEnabled = !hidden
        }
    }
    
    @objc public func handleTabBarButton(_ sender: UIButton) {
        
        button1.isSelected = false
        button2.isSelected = false
        
        sender.isSelected = true
        
        switchToTab(sender.tag - 1)
    }
}
