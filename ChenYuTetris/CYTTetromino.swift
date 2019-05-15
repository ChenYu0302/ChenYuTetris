//
//  CYTTetrominoes.swift
//  ChenYuTetris
//
//  Created by 陈宇 on 2018/12/24.
//  Copyright © 2018 陈宇. All rights reserved.
//

import Foundation

struct CYTTetromino {
    // MARK: - Tetromino Case
    enum TetrominoType:Int {
        case I = 1
        case J = 2
        case L = 3
        case O = 4
        case S = 5
        case Z = 6
        case T = 7
    }
    
    enum Orient: Int {
        case up = 1
        case left = 2
        case right = 3
        case down = 4
    }
    
    // MARK: - Property
    
    let type: CYTTetromino.TetrominoType
    var orient: CYTTetromino.Orient
    var bools:[[Bool]] {
        switch self.type {
        case .I:
            switch self.orient {
            case .left,.right:
                return [[true,true,true,true]] //I↩️ I↪️
            case .up,.down:
                return [[true],[true],[true],[true]] //I
            }
        case .J:
            switch self.orient {
            case .up:
                return [[false,true],[false,true],[true,true]]//J
            case .down:
                return [[true,true],[true,false],[true,false]] //J🔄
            case .left:
                return [[true,false,false],[true,true,true]] //J↩️
            case .right:
                return [[true,true,true],[false,false,true]] //J↪️

            }
        case .L:
            switch self.orient {
            case .up:
                return [[true,false],[true,false],[true,true]] //L
            case .down:
                return [[true,true],[false,true],[false,true]] //L🔄
            case .left:
                return [[true,true,true],[true,false,false]] //L↩️
            case .right:
                return [[false,false,true],[true,true,true]] //L↪️
            }
        case .O:
            return [[true,true],[true,true]]
        case .S:
            switch self.orient {
            case .up, .down:
                return [[false,true,true],[true,true,false]] //S
            case .left, .right:
                return [[true,false],[true,true],[false,true]] //S↩️ S↪️
            }
        case .T:
            switch self.orient {
            case .up:
                return [[true,true,true],[false,true,false]]//T
            case .down:
                return [[false,true,false],[true,true,true]]//丄
            case .left:
                return [[true,false],[true,true],[true,false]]//卜
            case .right:
                return [[false,true],[true,true],[false,true]]//反卜
            }
        case .Z:
            switch self.orient {
            case .up, .down:
                return [[true,true,false],[false,true,true]] //Z
            case .left, .right:
                return [[false,true],[true,true],[true,false]] //Z↩️ Z↪️
            }
        }
    }
    
    // MARK: - Method
    
    mutating func rotate() {
        switch self.orient {
        case .up:
            self.orient = .left
        case .left:
            self.orient = .down
        case .down:
            self.orient = .right
        case .right:
            self.orient = .up
        }
    }
    
    // MARK: - Initialize Randomly
    init() {
        self.type = CYTTetromino.TetrominoType(rawValue: Int.random(in: 1...7))!
        self.orient = CYTTetromino.Orient(rawValue: Int.random(in: 1...4))!
    }
}
