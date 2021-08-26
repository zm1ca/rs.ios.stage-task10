//
//  NewGameVC+TableView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

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
