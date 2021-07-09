//
//  Difficulty.swift
//  X@0's
//
//  Created by Ayush Khanna on 22/06/2021.
//

import Foundation

enum Diffculty: String, CaseIterable, Identifiable {
    var id: Diffculty { self }
    
    case easy
    case medium
    case hard
    
}

enum Player {
    case human
    case computer
}

struct Move {
    var player: Player
    var boardIndex: Int
    
    var image: String {
        return player == .computer ? "xmark" : "circle"
    }
}
