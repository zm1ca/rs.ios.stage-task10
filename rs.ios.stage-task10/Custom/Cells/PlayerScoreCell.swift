//
//  PlayerScoreCell.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 26.08.21.
//

import UIKit

class PlayerScoreCell: UICollectionViewCell {
    
    let playerNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 28)
        lbl.textColor = .RSGolden
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let scoreLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Nunito-ExtraBold", size: 100)
        lbl.textColor = .RSNearWhite
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    static let reuseID = "PlayerScoreCell"
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .RSTable
        configure()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Configurations
    func set(with playerName: String, and score: Int) {
        playerNameLabel.text = playerName.uppercased()
        scoreLabel.text      = "\(score)"
    }
    
    private func configure() {
        layer.cornerRadius = 15
        backgroundColor    = .RSTable
    }
    
    private func layoutUI() {
        addSubview(playerNameLabel)
        addSubview(scoreLabel)
        NSLayoutConstraint.activate([
            playerNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            playerNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            playerNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            scoreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            scoreLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
