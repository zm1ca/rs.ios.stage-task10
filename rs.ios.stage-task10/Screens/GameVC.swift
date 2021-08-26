//
//  GameVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class GameVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Game"
        view.backgroundColor = .RSBackground
        configureBarButtons()
    }
    
    private func configureBarButtons() {
        let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameButtonTapped))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = backButton
        
        let addButton = UIBarButtonItem(title: "Results", style: .plain, target: self, action: #selector(resultsButtonTapped))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func newGameButtonTapped() {
        let newGameVC      = NewGameVC()
        newGameVC.parentVC = self
        let navVC = UINavigationController(rootViewController: newGameVC)
        
        present(navVC, animated: true)
    }
    
    @objc private func resultsButtonTapped() {
        print("results")
    }
    
    func configure(with playerNames: [String]) {
        print("configured with", playerNames)
    }

}
