//
//  StaticFigure.swift
//  ChenYu_Tetris
//
//  Created by FutureHub on 17/12/7.
//  Copyright © 2017年 Rowling. All rights reserved.
//  俄罗斯方块已经下落的静态图形类

import UIKit

class StaticFigure: NSObject {
    init(gamerow: Int, gamecolumn: Int) {
        self.gamerow = gamerow
        self.gamecolumn = gamecolumn
        self.staticfigure = Array(repeating:Array(repeating:false, count:gamecolumn), count:gamerow-1)
        self.staticfigure.append(Array(repeating:true, count:gamecolumn))
    }
    
    //这个类中，行列数决定staticfigure，行列数不可变
    let gamerow:Int
    let gamecolumn:Int
    var staticfigure:[[Bool]]
    
    
    //MARK: - 给副本使用函数：传入操作后的动态图像副本，判断操作合法性
    func determineLegal(copyCurrentFigure:MovingFigure) -> Bool {
        //保证行数相等
        if copyCurrentFigure.extendfig().count != self.staticfigure.count {
            return false    //保证行数相等
        }
        if copyCurrentFigure.extendfig()[0].count != self.staticfigure[0].count {
            return false    //保证列数相等
        }
        //使用for循环的嵌套来合并游戏界面
        for r in 0..<self.gamerow {//地板层也要判断，因为MovingFigure没有地板
            for c in 0..<self.gamecolumn {
                if (copyCurrentFigure.extendfig()[r][c] && self.staticfigure[r][c]){
                    //若同一位置界面1和2都为真，也视为不合法
                    return false
                }
            }
        }
        return true
    }
    
    //将currentFigure合并到staticFigure上
    func addMovingFigure(currentFigure:MovingFigure) {
        let extendfig = currentFigure.extendfig()
        //使用for循环的嵌套来合并游戏界面
        for r in 0..<self.gamerow {
            for c in 0..<self.gamecolumn {
                    self.staticfigure[r][c] = (extendfig[r][c] || self.staticfigure[r][c])
            }
        }
    }


//    消去满行
    func eliminate() -> Int{
        var score:Int = 0
        var staticfigure_eliminate = self.staticfigure
        for i in 0...(self.gamerow-2) {
            if staticfigure[i].contains(false) {
                continue
            }
            else
            {
                staticfigure_eliminate.remove(at: i)
                staticfigure_eliminate.insert(Array(repeating:false, count:self.gamecolumn) , at: 0)//补充零行
                score = score + 1
            }
        }
        self.staticfigure = staticfigure_eliminate
        return score
    }
    
    //显示静态游戏界面
    func show() {
        for i in 0..<self.gamerow {
            for j in 0..<self.gamecolumn {
                if self.staticfigure[i][j] {
                    print("x", separator: "", terminator: "")//真输出x
                }
                else{
                    print("o", separator: "", terminator: "")//假输出o
                }
            }
            print(" ", separator: "", terminator:"")
            print(i)
        }
    }
}
