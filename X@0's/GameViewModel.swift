//
//  GameViewModel.swift
//  X@0's
//
//  Created by Ayush Khanna on 22/06/2021.
//

import SwiftUI

class GameViewModel: ObservableObject{

    @Published var moves: [Move?] = Array.init(repeating: nil, count: 9)
    @Published var isGameBoardDsiabled = false
    @Published var alertItem: AlertItem?
    @Published var showSettings = false
    @Published var difficulty = Diffculty.easy
    @Published var computerGoesFirst = false
    
    let colums: [GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]
    
    func processPlayerMove(for position: Int ) {
        
        if isSquareOccupied(in: moves, index: position){
            return
        }
        
        //Play Human move
        moves[position] = Move(player: .human , boardIndex: position)
        isGameBoardDsiabled = true
        
        //Check Human win
        if checkWinCondition(for: .human, in: moves) {
            print("Human Won")
            alertItem = AlertContext.humanWin
            return
        }
        
        //Check Computer win
        if checkForDraw(in: moves) {
            print("Draw")
            alertItem = AlertContext.draw
            return
        }
        
        //Play computer move
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.5) {
            let computerMove = self.determineComputerMove(moves: self.moves)
            
            DispatchQueue.main.async {
                self.moves[computerMove] = Move(player: .computer , boardIndex: computerMove)
                self.isGameBoardDsiabled = false
                
                if self.checkWinCondition(for: .computer, in: self.moves) {
                    print("computer won")
                    self.alertItem = AlertContext.computerWin
                    return
                }
                
                if self.checkForDraw(in: self.moves) {
                    print("Draw")
                    self.alertItem = AlertContext.draw
                    return
                }
            }
        }
    }

    private func determineComputerMove(moves: [Move?]) -> Int {
        switch difficulty {
        case .easy:
            return determineComputerMovePositionEasy(in: moves)
        case .medium:
            return determineComputerMovePositionMedium(in: moves)
        case .hard:
            return determineComputerMovePositionHard(in: moves)
        }
    }
    
    func playCompFirstMove() {
        isGameBoardDsiabled = true
        DispatchQueue.main.async { [self] in
            let randomArr = [0,2,6,8]
            let r = randomArr[Int.random(in: 0..<4)]
            moves[r] = Move(player: .computer , boardIndex: r)
            isGameBoardDsiabled = false
        }
    }
    
    func isSquareOccupied(in moves:[Move?], index: Int) -> Bool {
        return moves.contains(where :{$0?.boardIndex == index})
    }
    
    func determineComputerMovePositionEasy(in moves: [Move?]) -> Int {
        var move = Int.random(in: 0..<9)
        while isSquareOccupied(in: moves, index: move) {
            move = Int.random(in: 0..<9)
        }
        return move
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winConditions: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        let playerMoves = moves.compactMap { $0 }.filter() { $0.player == player }
        let playerPositions = playerMoves.map() { $0.boardIndex }
        
        for condition in winConditions {
            if condition.isSubset(of: playerPositions) {
                return true
            }
        }
        return false
        
    }
    
    func determineComputerMovePositionMedium(in moves: [Move?]) -> Int {
        let winConditions: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
        
        
        let playerMoves = moves.compactMap { $0 }.filter() { $0.player == .human }
        let playerPositions = playerMoves.map() { $0.boardIndex }
        let computerMoves = moves.compactMap { $0 }.filter() { $0.player == .computer }
        let computerPositions = computerMoves.map() { $0.boardIndex }
        
        //Check for if a win condition coming up
        for condition in winConditions {
        
            var matchingMoves = 0
            for pos in computerPositions {
                if condition.contains(pos){
                    matchingMoves+=1
                }
                if matchingMoves == 2 {
                    var unMatchedMoveIndex = -1
                    condition.forEach { pos in
                        if !computerPositions.contains(pos){
                            unMatchedMoveIndex = pos
                        }
                    }
                    
                    if unMatchedMoveIndex != -1 {
                        if !isSquareOccupied(in: moves, index: unMatchedMoveIndex) {
                            return unMatchedMoveIndex
                            
                        }
                    } else {
                        fatalError()
                    }
                }
            }
        }
        
        //Check if human move has to be blocked
        for condition in winConditions {
            var matchingMoves = 0
            playerPositions.forEach { pos in
                if condition.contains(pos){
                    matchingMoves+=1
                }
            }
            if matchingMoves == 2 {
                var unMatchedMoveIndex = -1
                condition.forEach { pos in
                    if !playerPositions.contains(pos){
                        unMatchedMoveIndex = pos
                    }
                }
                
                if unMatchedMoveIndex != -1 {
                    if !isSquareOccupied(in: moves, index: unMatchedMoveIndex) {
                        return unMatchedMoveIndex
                        
                    }
                }
            }
        }
        
        //occupy centre
        if !isSquareOccupied(in: moves, index: 4) {
            return 4
        }
        
        //Return random
        return determineComputerMovePositionEasy(in: moves)
    
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        moves.compactMap() { $0 }.count == 9
    }
    
    func resetGame() {
        self.moves = Array.init(repeating: nil, count: 9)
        isGameBoardDsiabled = true
        
        if computerGoesFirst {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                isGameBoardDsiabled = false
                playCompFirstMove()
            }
        } else {
            isGameBoardDsiabled = false
        }
    }
    
    func determineComputerMovePositionHard(in moves: [Move?]) -> Int {
        
        var bestMove = -1
        var bestScore = Int.min
        for i in 0..<9 {
            if !isSquareOccupied(in: moves, index: i){
                var m = moves
                m[i] = Move(player: .computer, boardIndex: i)
                let score = miniMax(miniMoves: m, player: .human)
                
                if score > bestScore {
                    bestMove = i
                    bestScore = score
                }
            }
        }
        
        if bestMove == -1 {
            fatalError()
        }
        
        return bestMove
    }
    
    func miniMax(miniMoves: [Move?], player: Player) -> Int {
        if checkWinCondition(for: .computer, in: miniMoves) {
            return 1
        }
        if checkWinCondition(for: .human, in: miniMoves) {
            return -1
        }
        if checkForDraw(in: miniMoves) {
            return 0
        }
        
        if player == .computer {
            var bestScore = Int.min
            for i in 0..<9 {
                if !isSquareOccupied(in: miniMoves, index: i) {
                    var m = miniMoves
                    m[i] = Move(player: .computer, boardIndex: i)
                    
                    let score = miniMax(miniMoves: m, player: .human)
                    bestScore = max(bestScore, score)
                }
            }
            return bestScore
            
        } else {
            var bestScore = Int.max
            for i in 0..<9 {
                if !isSquareOccupied(in: miniMoves, index: i) {
                    var m = miniMoves
                    m[i] = Move(player: .human, boardIndex: i)
                    
                    let score = miniMax(miniMoves: m, player: .computer)
                    bestScore = min(bestScore, score)
                }
            }
            return bestScore
        }
    }
}
