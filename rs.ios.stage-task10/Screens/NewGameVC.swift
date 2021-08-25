//
//  ViewController.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 25.08.21.
//

import UIKit

class NewGameVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Game Counter"
        view.backgroundColor = UIColor.RSBackground
        
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(handleCancel)
        )
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.tintColor = .clear
    }
    
    @objc private func handleCancel() {
        print("Cancel")
    }


}

