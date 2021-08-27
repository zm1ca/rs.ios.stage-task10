//
//  ViewController.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 25.08.21.
//

import UIKit

class NewGameVC: UIViewController {
    
    weak var parentVC: GameVC?
    var playerNames = ["Me", "You"]
    var tableViewHeightConstraint: NSLayoutConstraint!
    
    let headerView = HeaderView(title: "Game Counter")
    let tableView  = UITableView(frame: .zero, style: .plain)
    
    let cancelButton = BarButton(title: "Cancel")
    
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
        tableViewHeightConstraint.constant = CGFloat((playerNames.count + 1) * 54 + 45)
        super.viewWillAppear(animated)
    }
    
    
    // MARK: Configurations
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlayerCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .RSTable
        tableView.layer.cornerRadius = 15
        tableView.separatorColor = .RSSeparator
        tableView.setEditing(true, animated: false)
    }
    
    private func configureCancelButton() {
        cancelButton.isHidden = (parentVC == nil)
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    
    // MARK: - Layout
    private func layoutUI() {
        view.addSubview(headerView)
        headerView.addSubview(cancelButton)
        view.addSubview(tableView)
        view.addSubview(startButton)
        
        tableViewHeightConstraint = NSLayoutConstraint(
            item: tableView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: CGFloat((playerNames.count + 1) * 54 + 45)
        )
        tableViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            headerView.heightAnchor.constraint(equalToConstant: 90),
            
            cancelButton.bottomAnchor.constraint(equalTo: headerView.titleLabel.topAnchor, constant: -12),
            cancelButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -65),
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 65),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableViewHeightConstraint,
        ])
    }

}

extension NewGameVC: PlayerAddable {
    func addPlayer(named name: String) {
        playerNames.append(name)
        tableView.reloadData()
    }
}

