//
//  RankingsCell.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class RankingView: UIView {
    
    private var rankLabel: UILabel = {
        let lbl  = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var nameLabel: UILabel = {
        let lbl  = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        lbl.textColor = .RSGolden
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private var scoreLabel: UILabel = {
        let lbl  = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .RSBackground
        addSubview(rankLabel)
        addSubview(nameLabel)
        addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            rankLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            rankLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 10),
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(rank: Int, for name: String, with score: Int) {
        rankLabel.text = "#\(rank)"
        nameLabel.text = name
        scoreLabel.text = "\(score)"
    }
    
}
