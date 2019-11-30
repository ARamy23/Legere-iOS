//
//  Searchbar.swift
//  Legere
//
//  Created by Ahmed Ramy on 5/3/19.
//  Copyright © 2019 Ahmed Ramy. All rights reserved.
//

import UIKit

final public class Searchbar: BaseCustomView {
    @IBOutlet weak var searchTextField: UITextField!
    
    init() {
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 50, height: 50)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
