//
//  RankingsCollectionCell.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 28.08.21.
//

import UIKit

class RankingsCollectionCell: UICollectionViewCell {
    
    let stackView: UIStackView = {
       let sv = UIStackView()
        sv.axis         = .vertical
        sv.spacing      = 0
        sv.distribution = .fillEqually
        for _ in 1...3 {
            sv.addArrangedSubview(RankingView())
        }
        return sv
    }()
    
    static let reuseID = "RankingsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .RSBackground
        addSubview(stackView)
        stackView.pinToEdges(of: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with rankings: [(Int, String, Int)]) {
        for i in 0..<rankings.count {
            let rankingView    = stackView.arrangedSubviews[i] as! RankingView
            let currentRanking = rankings[i]
            rankingView.set(rank: currentRanking.0, for: currentRanking.1, with: currentRanking.2)
        }
    }
    
}
