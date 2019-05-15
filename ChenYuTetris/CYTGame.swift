//
//  Game.swift
//  ChenYuTetris
//
//  Created by 陈宇 on 2018/12/24.
//  Copyright © 2018 陈宇. All rights reserved.
//

import Foundation

protocol TetrisGameDelegate: class {
    func tetrisChange(score: Int)
    func tetrisChange(bools: [[Bool]])
    func tetrisChange(nextTetromino: CYTTetromino)
    func tetrisGameEnd()
}

class CYTGame:NSObject {
    
    enum Action {
        case goUp
        case goLeft
        case goRight
        case goDown
    }
    
    // MARK: - Privite Property
    
    private let row: Int
    private let column: Int
    
    private weak var timer: Timer?
    private var timeInterval:Double = 1
    
    private var currentTetromino:CYTTetromino
    private var nextTetromino:CYTTetromino

    private var x: Int
    private var y: Int = 0
    
    private var reach2ground:Bool = false
    private(set) var score: Int = 0
    
    private var staticBools:[[Bool]]
    private var bools:[[Bool]] {
        var bools = self.staticBools
        for r in self.currentTetromino.bools.indices {
            for c in self.currentTetromino.bools.first!.indices {
                if self.currentTetromino.bools[r][c] {
                    bools[r + self.y][c + self.x] = self.currentTetromino.bools[r][c]
                }
            }
        }
        return bools
    }
    
    // MARK: - Public Property
    
    weak var delegate:TetrisGameDelegate?
    
    // MARK: - Life Circle
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.staticBools = Array(repeating:Array(repeating: false, count: column), count: row)
        self.currentTetromino = CYTTetromino()
        self.nextTetromino = CYTTetromino()
        self.x = (column - self.currentTetromino.bools[0].count)/2 - 1
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
    // MARK: - Public Method
    
    func act(_ action: Action)
    {
        var newTetromino = self.currentTetromino
        var newX = self.x
        var newY = self.y
        
        switch action {
        case .goUp:
            newTetromino.rotate()
        case .goLeft:
            newX -= 1
        case .goRight:
            newX += 1
        case .goDown:
            newY += 1
        }
        
        let maxX = (self.column - 1) - (newTetromino.bools.first!.count - 1)
        let maxY = (self.row - 1) - (newTetromino.bools.count - 1)
        if newX > maxX { return }
        if newX < 0 { return }
        if newY > maxY { return }
        if newY < 0 { return }
        for r in newTetromino.bools.indices {
            for c in newTetromino.bools.first!.indices {
                if self.staticBools[newY + r][newX + c] && newTetromino.bools[r][c] {
                    return
                }
            }
        }
        
        self.currentTetromino = newTetromino
        self.x = newX
        self.y = newY
        self.delegate?.tetrisChange(bools: self.bools)
    }
    
    
    func start() {
        self.delegate?.tetrisChange(nextTetromino: self.nextTetromino)
        self.delegate?.tetrisChange(score: self.score)
        self.delegate?.tetrisChange(bools: self.bools)
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: true, block: { (timer) in
            let oldY = self.y
            self.act(.goDown)
            if self.y == oldY {
                if self.reach2ground {
                    self.reach2ground = false
                    self.staticBools = self.bools
                    self.currentTetromino = self.nextTetromino
                    self.x = (self.column - self.currentTetromino.bools[0].count)/2 - 1
                    self.y = 0
                    self.nextTetromino = CYTTetromino()
                    
                    self.delegate?.tetrisChange(bools: self.bools)
                    self.delegate?.tetrisChange(nextTetromino: self.nextTetromino)
                    
                    // Calculate Score
                    for i in self.staticBools.indices {
                        if !(self.staticBools[i].contains(false)) {
                            self.staticBools.remove(at: i)
                            let falseArray = Array(repeating: false, count: self.column)
                            self.staticBools.insert(falseArray, at: 0)
                            self.score += 1
                        }
                    }
                    self.delegate?.tetrisChange(score: self.score)
                    
                    // Game End
                    for r in self.currentTetromino.bools.indices {
                        for c in self.currentTetromino.bools.first!.indices {
                            if self.staticBools[self.y + r][self.x + c] && self.currentTetromino.bools[r][c] {
                                timer.invalidate()
                                self.delegate?.tetrisGameEnd()
                            }
                        }
                    }
                    
                } else {
                    self.reach2ground = true
                }
            }
        })
    }
}
