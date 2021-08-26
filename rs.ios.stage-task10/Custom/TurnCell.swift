//
//  TurnCell.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class TurnCell: UITableViewCell {
    
    private var nameLabel: UILabel = {
        let lbl  = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var scoreLabel: UILabel = {
        let lbl  = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 20)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }() //same as above

    static let reuseID = "TurnCell"
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .RSTable
        addSubview(nameLabel)
        addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configuration
    func set(name: String, score: Int) {
        nameLabel.text = name
        if score > 0 {
            scoreLabel.text = "+\(score)"
        } else {
            scoreLabel.text = "\(score)"
        }
        
    }
    

}
