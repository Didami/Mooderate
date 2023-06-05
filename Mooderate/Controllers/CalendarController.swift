//
//  CalendarController.swift
//  Mooderate
//
//  Created by Didami on 05/06/23.
//

import UIKit

class CalendarController: UIViewController {
    
    var parentController: ParentController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .background
    }
}
