//
//  ResultsVC+CollectionView.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 28.08.21.
//

import UIKit

extension ResultsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        (playerScores.count + 2) / 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RankingsCollectionCell.reuseID, for: indexPath) as! RankingsCollectionCell
        
        var rankings = [(Int, String, Int)]()
        for i in 0...2 {
            let currentIndex = 3 * indexPath.row + i
            if playerScores.count > currentIndex {
                rankings.append((currentIndex + 1, playerScores[currentIndex].0, playerScores[currentIndex].1))
            }
        }
        
        cell.set(with: rankings)
        return cell
    }
}
