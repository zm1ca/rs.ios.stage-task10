//
//  ResultsVC.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class ResultsVC: UIViewController {
    
    weak var parentVC: GameVC?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Results"
        view.backgroundColor = .RSBackground
        configureBarButtons()
    }
    
    private func configureBarButtons() {
        let backButton = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGameButtonTapped))
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.leftBarButtonItem = backButton
        
        let resumeButton = UIBarButtonItem(title: "Resume", style: .plain, target: self, action: #selector(resumeButtonTapped))
        self.navigationItem.rightBarButtonItem = resumeButton
    }
    
    @objc private func newGameButtonTapped() {
        let newGameVC = NewGameVC()
        newGameVC.parentVC = parentVC
        navigationController?.pushViewController(newGameVC, animated: true)
    }
    
    @objc private func resumeButtonTapped() {
        dismiss(animated: true)
    }

}
