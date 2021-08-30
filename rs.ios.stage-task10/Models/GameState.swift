//
//  GameState.swift
//  rs.ios.stage-task10
//
//  Created by Źmicier Fiedčanka on 30.08.21.
//

import Foundation

struct GameState: Codable {
    let playerScores:    [PlayerScore]
    let turns:           [Turn]
    let currentPosition: Int
    let startTime:       TimeInterval?
    let pauseTime:       TimeInterval?
}
