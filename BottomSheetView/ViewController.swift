//
//  ViewController.swift
//  BottomSheetView
//
//  Created by Isaías Santana on 23/09/19.
//  Copyright © 2019 Isaías Santana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let bottomSheet: BottomSheetView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let bottomSheet = BottomSheetView(contentView: contentView)
        return bottomSheet
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let button = UIButton()
        view.addSubview(button)
        button.centerInSuperview()
        button.setTitle("Touch me", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(touchButton), for: .touchDown)
    }


   @objc private func touchButton() {
        bottomSheet.show()
    }
}

