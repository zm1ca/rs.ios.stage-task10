//
//  ViewController.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 25.08.21.
//

import UIKit

class NewGameVC: UIViewController {
    
    weak var parentVC: GameVC?
    var playerNames = ["Me", "You", "Kate", "Tim", "Josua"]
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    let headerView = HeaderView(title: "Game Counter",
                                leftBarButton: BarButton(title: "Cancel"),
                                rightBarButton: nil)
    let tableView  = UITableView(frame: .zero, style: .plain)
    
    let startButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .RSGreen
        btn.layer.cornerRadius = 65 / 2
        btn.layer.masksToBounds = false
        
        let shadow = NSShadow()
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
        btn.addTarget(self, action: #selector(startGameButtonTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    @objc private func startGameButtonTapped() {
        guard let parentVC = parentVC else {
            let gameVC = GameVC()
            gameVC.configure(with: self.playerNames)
            navigationController?.pushViewController(gameVC, animated: true)
            return
        }
        
        dismiss(animated: true) {
            parentVC.configure(with: self.playerNames)
        }
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(UIView())
        title = "Game Counter"
        view.backgroundColor = UIColor.RSBackground
        
        configureTableView()
        configureCancelButton()
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let tableViewContentHeight = CGFloat((playerNames.count + 1) * 54 + 45)
        tableViewHeightConstraint.constant = min(tableViewContentHeight, UIScreen.main.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 285)
        super.viewWillAppear(animated)
    }
    
    
    // MARK: Configurations
    private func configureCancelButton() {
        headerView.leftBarButton?.isHidden = (parentVC == nil)
        headerView.leftBarButton?.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        headerView.addSubviewAndConstraintByDefault(at: view)
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

extension NewGameVC: PlayerAddable {
    func addPlayer(named name: String) {
        playerNames.append(name)
        tableView.reloadData()
        startButton.isEnabled = true
        startButton.alpha     = 1
    }
}

