//
//  ResultsVC+TableView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 27.08.21.
//

import UIKit

extension ResultsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        turns.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TurnCell.reuseID, for: indexPath) as! TurnCell
        let playerName = turns[indexPath.row].0
        let score      = turns[indexPath.row].1
        cell.set(name: playerName, score: score)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 45))
        
        let label = UILabel()
        label.frame     = CGRect.init(x: 16, y: 5, width: headerView.frame.width - 26, height: headerView.frame.height)
        label.text      = "Turns"
        label.font      = UIFont(name: "Nunito-SemiBold", size: 16) //letter l is rounded wtf
        label.textColor = .RSLabel
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
    
}
