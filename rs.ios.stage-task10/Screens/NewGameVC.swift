//
//  ViewController.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 25.08.21.
//

import UIKit

class NewGameVC: UIViewController {
    
    let startButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .RSGreen
        btn.layer.cornerRadius = 65 / 2
        btn.layer.masksToBounds = false
        
        var shadow = NSShadow()
        shadow.shadowColor = UIColor.RSShadow
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        
        let attributedTitle = NSAttributedString(
            string: "Start Game",
            attributes: [
                NSAttributedString.Key.font: UIFont(name: "Nunito-ExtraBold", size: 24)!,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.shadow: shadow
            ]
        )
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Game Counter"
        view.backgroundColor = UIColor.RSBackground
        configureCancelButton()
        layoutUI()
    }
    
    private func configureCancelButton() {
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
    
    private func layoutUI() {
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -65),
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }

}

