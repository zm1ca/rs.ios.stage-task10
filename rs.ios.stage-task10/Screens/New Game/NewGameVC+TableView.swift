//
//  NewGameVC+TableView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

extension NewGameVC: UITableViewDelegate, UITableViewDataSource  {
    
    func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlayerCell")
        tableView.register(HeaderCell.self, forCellReuseIdentifier: HeaderCell.reuseID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate           = self
        tableView.dataSource         = self
        tableView.tableFooterView    = UIView()
        tableView.backgroundColor    = .RSTable
        tableView.layer.cornerRadius = 15
        tableView.separatorColor     = .RSSeparator
        tableView.allowsSelection    = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playerNames.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return configuredHeaderCell(for: tableView, at: indexPath)
        case playerNames.count + 1:
            return configuredFooterCell(for: tableView, at: indexPath)
        default:
            return configuredPlayerCell(for: tableView, at: indexPath)
        }
    }
    
    private func configuredHeaderCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderCell.reuseID, for: indexPath) as! HeaderCell
        cell.set(title: "Players")
        return cell
    }
    
    private func configuredFooterCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        cell.backgroundColor = .RSTable
        cell.imageView?.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(addPlayerIconTapped))
        cell.imageView?.addGestureRecognizer(tap)
        cell.imageView?.image     = UIImage(named: "add")
        
        cell.textLabel?.textColor = .RSGreen
        cell.textLabel?.font      = UIFont(name: "Nunito-SemiBold", size: 16)
        cell.textLabel?.text      = "Add player"
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width * 2)
        cell.accessoryView  = nil
        return cell
    }
    
    private func configuredPlayerCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        cell.backgroundColor = .RSTable
        cell.imageView?.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(deletePlayerIconTapped))
        cell.imageView?.addGestureRecognizer(tap)
        cell.imageView?.image     = UIImage(named: "delete")
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font      = UIFont(name: "Nunito-ExtraBold", size: 20)
        cell.textLabel?.text      = playerNames[indexPath.row - 1]
        
        cell.accessoryView = UIImageView(image: UIImage(named: "sort"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        54
    }
    
    @objc private func deletePlayerIconTapped(sender: UIGestureRecognizer) {
        if let cell = sender.view?.superview?.superview as? UITableViewCell {
            let indexPath = tableView.indexPath(for: cell)!
            playerNames.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
            tableViewHeightConstraint.constant = CGFloat((playerNames.count + 1) * 54 + 45)
            view.setNeedsLayout()
            
            if playerNames.isEmpty {
                startButton.isEnabled = false
                startButton.alpha     = 0.5
            }
        }
    }
    
    @objc private func addPlayerIconTapped() {
        let addPlayerVC = AddPlayerVC()
        addPlayerVC.delegate = self
        navigationController?.pushViewController(addPlayerVC, animated: true)
    }
    
}
