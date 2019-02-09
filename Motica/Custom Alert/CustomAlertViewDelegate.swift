//
//  CustomAlertViewDelegate.swift
//  Motica
//
//  Created by Seah Family on 12/1/19.
//  Copyright © 2019 Jeremy. All rights reserved.
//

protocol CustomAlertViewDelegate: class {
    
    func okButtonTapped(selectedOption: Int, title: String, sub: String)
    func cancelButtonTapped()
    
}
