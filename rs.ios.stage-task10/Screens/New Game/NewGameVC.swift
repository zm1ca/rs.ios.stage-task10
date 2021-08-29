//
//  ViewController.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 25.08.21.
//

import UIKit

class NewGameVC: UIViewController {
    
    var presentingGameVC: GameVC? {
        (presentingViewController as? UINavigationController)?.viewControllers.first as? GameVC
    }
    
    var isPresentedModally: Bool {
        presentingGameVC != nil
    }
    
    var playerNames = ["Me", "You"]
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Views
    let headerView = HeaderView(title: "Game Counter",
                                leftBarButton: BarButton(title: "Cancel"),
                                rightBarButton: nil)
    let tableView  = UITableView(frame: .zero, style: .plain)
    let startButton = StartGameButton()
    

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(UIView())
        title = "Game Counter"
        view.backgroundColor = UIColor.RSBackground
        startButton.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        
        configureTableView()
        configureCancelButton()
        layoutUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let tableViewContentHeight = CGFloat((playerNames.count + 2) * 54)
        let modalCompensation: CGFloat = isPresentedModally ? 0 : 54
        tableViewHeightConstraint.constant = min(tableViewContentHeight, UIScreen.main.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 334 + modalCompensation)
    }
    
    
    // MARK: Configurations
    private func configureCancelButton() {
        headerView.leftBarButton?.isHidden = !isPresentedModally
        headerView.leftBarButton?.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func startGameButtonTapped() {
        guard let gameVC = presentingGameVC else {
            let gameVC = GameVC()
            gameVC.setUpNewGame(with: self.playerNames)
            navigationController?.setViewControllers([gameVC], animated: true)
            return
        }
        
        dismiss(animated: true) {
            gameVC.setUpNewGame(with: self.playerNames)
        }
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        headerView.placeByDefault(at: view)
        view.addSubviews(tableView, startButton)
        
        tableViewHeightConstraint = NSLayoutConstraint(
            item: tableView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 0
        )
        tableViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -65),
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 65),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableViewHeightConstraint
        ])
    }

}
