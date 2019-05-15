//
//  GameViewController.swift
//  ChenYuTetris
//
//  Created by 陈宇 on 2018/12/24.
//  Copyright © 2018 陈宇. All rights reserved.
//

import UIKit

class CYTGameViewController: UIViewController,TetrisGameDelegate {
    
    var game:CYTGame?
    
    // MARK:- Interface Builder Action
    
    @IBAction func upButtonTouched() { self.game?.act(.goUp) }
    @IBAction func leftButtonTouched() { self.game?.act(.goLeft) }
    @IBAction func rightButtonTouched() { self.game?.act(.goRight) }
    @IBAction func downButtonTouched() { self.game?.act(.goDown) }
    
    // MARK:- Interface Builder Outlet
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mainGameView: CYTGameView!
    @IBOutlet weak var nextGameView: CYTGameView!
    
    // MARK:- Implement TetrisGameDelegate
    
    func tetrisChange(score: Int) {
        self.scoreLabel.text = "Score: \(score)"
    }
    
    func tetrisChange(bools: [[Bool]]) {
        self.mainGameView.bools = bools
        self.mainGameView.setNeedsDisplay()
    }
    
    func tetrisChange(nextTetromino: CYTTetromino) {
        if nextTetromino.bools.count < 4 {
            var bools = nextTetromino.bools
            bools.insert(Array(repeating: false, count: nextTetromino.bools[0].count), at: 0)
            self.nextGameView.bools = bools
        } else {
            self.nextGameView.bools = nextTetromino.bools
        }
        self.nextGameView.setNeedsDisplay()
    }
    
    func tetrisGameEnd() {
        let alert = UIAlertController(title: "Game Over", message: "Your Score: \(self.game?.score  ?? 0)", preferredStyle: .alert)
        let newGameAlertAction = UIAlertAction(title: "> New Game <", style: .default) { (action) in
            let newGame = CYTGame(row: self.mainGameView.rowCount, column: self.mainGameView.columnCount)
            newGame.delegate = self
            self.game = nil
            self.game = newGame
            self.game?.start()
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(newGameAlertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK:- ViewController Life Circle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let newGame = CYTGame(row: self.mainGameView.rowCount, column: self.mainGameView.columnCount)
        newGame.delegate = self
        self.game = newGame
        self.game?.start()
    }
}
