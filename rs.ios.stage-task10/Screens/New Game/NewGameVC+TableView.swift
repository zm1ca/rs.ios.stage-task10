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
        playerNames.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        cell.backgroundColor = .RSTable
        cell.imageView?.isUserInteractionEnabled = true
        
        if indexPath.row == playerNames.count {
            applyLastCellConfigurations(to: cell)
        } else {
            applyDefaultCellConfigurations(to: cell, at: indexPath)
        }
        
        return cell
    }
    
    private func applyLastCellConfigurations(to cell: UITableViewCell) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(addPlayerIconTapped))
        cell.imageView?.addGestureRecognizer(tap)
        cell.imageView?.image     = UIImage(named: "add")
        
        cell.textLabel?.textColor = .RSGreen
        cell.textLabel?.font      = UIFont(name: "Nunito-SemiBold", size: 16)
        cell.textLabel?.text      = "Add player"
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width * 2)
        cell.accessoryView  = nil
    }
    
    private func applyDefaultCellConfigurations(to cell: UITableViewCell, at indexPath: IndexPath) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(deletePlayerIconTapped))
        cell.imageView?.addGestureRecognizer(tap)
        cell.imageView?.image     = UIImage(named: "delete")
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.font      = UIFont(name: "Nunito-ExtraBold", size: 20)
        cell.textLabel?.text      = playerNames[indexPath.row]
        
        cell.accessoryView = UIImageView(image: UIImage(named: "sort"))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 45))
        
        let label = UILabel()
        label.frame     = CGRect.init(x: 16, y: 5, width: headerView.frame.width - 26, height: headerView.frame.height)
        label.text      = "Players"
        label.font      = UIFont(name: "Nunito-SemiBold", size: 16)
        label.textColor = .RSLabel
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
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
