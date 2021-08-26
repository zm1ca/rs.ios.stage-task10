//
//  ViewController.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 25.08.21.
//

import UIKit

class NewGameVC: UIViewController {
    
    weak var parentVC: GameVC?
    private var tableViewHeightConstraint: NSLayoutConstraint!
    private var playerNames = ["Me", "You"]
    private var tableView   = UITableView(frame: .zero, style: .plain)
    
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
    
    
    // MARK: Configuration
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
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(handleCancel)
        )
        self.navigationItem.leftBarButtonItem = cancelButton
        
        if parentVC == nil {
            self.navigationItem.leftBarButtonItem?.isEnabled = false
            self.navigationItem.leftBarButtonItem?.tintColor = .clear
        }
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    private func layoutUI() {
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
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -65),
            startButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 65),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableViewHeightConstraint,
        ])
    }

}

extension NewGameVC: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerNames.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        cell.backgroundColor = .RSTable
        
        if indexPath.row == playerNames.count {
            cell.textLabel?.textColor = .RSGreen
            cell.textLabel?.font      = UIFont(name: "Nunito-SemiBold", size: 16)
            cell.textLabel?.text      = "Add player"
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width * 2)
            return cell
        } else {
            cell.textLabel?.textColor = .white
            cell.textLabel?.font      = UIFont(name: "Nunito-ExtraBold", size: 20)
            cell.textLabel?.text      = playerNames[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        indexPath.row == playerNames.count ? .insert : .delete
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 45))
        
        let label = UILabel()
        label.frame     = CGRect.init(x: 16, y: 5, width: headerView.frame.width - 26, height: headerView.frame.height)
        label.text      = "Players"
        label.font      = UIFont(name: "Nunito-SemiBold", size: 16) //letter l is rounded wtf
        label.textColor = .RSLabel
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            playerNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableViewHeightConstraint.constant = CGFloat((playerNames.count + 1) * 54 + 45)
            view.setNeedsLayout()
        case .insert:
            let addPlayerVC = AddPlayerVC()
            addPlayerVC.delegate = self
            navigationController?.pushViewController(addPlayerVC, animated: true)
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
}

extension NewGameVC: PlayerAddable {
    func addPlayer(named name: String) {
        playerNames.append(name)
        tableView.reloadData()
    }
    
}

