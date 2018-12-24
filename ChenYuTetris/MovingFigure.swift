//
//  MovingFigure.swift
//  ChenYu_Tetris
//
//  Created by FutureHub on 17/12/7.
//  Copyright © 2017年 Rowling. All rights reserved.
//  俄罗斯方块正在下落的动态图形类

import UIKit

class MovingFigure: NSObject {
    
    //构造器：输入图形编号，x坐标，y坐标，游戏界面行数（默认最小值19，最后一行为真值作为地板），游戏界面列数（默认最小值12）
    init(number:Int, y:Int, x:Int, gamerow:Int, gamecolumn:Int) {
        self.number = MovingFigure.legalize_number(number: number)//保证数值合法
        self.x = MovingFigure.legalize_x(number: self.number, x: x, gamecolumn: gamecolumn)
        self.y = MovingFigure.legalize_y(number: self.number, y: y, gamerow: gamerow)
        self.gamerow = gamerow
        self.gamecolumn = gamecolumn
    }
    
    //类属性
    var number:Int//图形编号
    var x:Int//x坐标
    var y:Int//y坐标
    var gamerow:Int//游戏界面行数
    var gamecolumn:Int//游戏界面列数
    //    Tips:属性越少越好，方便类的创建。
    //    若属性之间保持一一对应的关系，则保留一个为属性，其他的改为成员函数，比如这里的图形编号和图形
    
    //    MARK:- 静态成员函数-----------------------------------------------------------------------------------
    
    //静态成员函数，图形编号合法化
    static func legalize_number(number:Int) -> Int {
        if number > 19 {
            return 19
        }
        if number < 1 {
            return 1
        }
        return number
    }
    
    //静态成员函数，x坐标合法化
    static func legalize_x(number:Int, x:Int, gamecolumn:Int) -> Int {
        let max:Int = gamecolumn - MovingFigure.num2fig(num: number)[0].count//此处有+1-1的抵消
        let min:Int = 0
        if x > max {
            return max
        }
        if x < min {
            return min
        }
        return x
    }
    
    //静态成员函数，y坐标合法化，y可以到达地板层
    static func legalize_y(number:Int, y:Int, gamerow:Int) -> Int {
        let max:Int = gamerow - MovingFigure.num2fig(num: number).count//此处有+1-1的抵消
        let min:Int = 0
        if y > max {
            return max
        }
        if y < min {
            return min
        }
        return y
    }
    
    //静态成员函数，将图形编号转为图形（二维Bool数组）
    static func num2fig(num:Int) -> [[Bool]] {
        switch num {
        case 1:
            return [[true,false],[true,true],[false,true]]//竖s
        case 2:
            return [[false,true,true],[true,true,false]]//s
        case 3:
            return [[false,true],[true,true],[true,false]]//竖z
        case 4:
            return [[true,true,false],[false,true,true]]//z
        case 5:
            return [[true,false],[true,false],[true,true]]//L
        case 6:
            return [[true,true,true],[true,false,false]]//L↩️
        case 7:
            return [[true,true],[false,true],[false,true]]//L🔄
        case 8:
            return [[false,false,true],[true,true,true]]//L↪️
        case 9:
            return [[false,true],[false,true],[true,true]]//J
        case 10:
            return [[true,false,false],[true,true,true]]//J↩️
        case 11:
            return [[true,true],[true,false],[true,false]]//J🔄
        case 12:
            return [[true,true,true],[false,false,true]]//J↪️
        case 13:
            return [[true,true],[true,true]]//田
        case 14:
            return [[true],[true],[true],[true]]//1
        case 15:
            return [[true,true,true,true]]//一
        case 16:
            return [[false,true,false],[true,true,true]]//丄
        case 17:
            return [[true,false],[true,true],[true,false]]//卜
        case 18:
            return [[true,true,true],[false,true,false]]//T
        case 19:
            return [[false,true],[true,true],[false,true]]//反卜
        default://默认是1
            return [[true,false],[true,true],[false,true]]//竖s
        }
    }
    
    //    MARK:- 普通成员函数-----------------------------------------------------------------------------------
    
    func movingfigure() -> [[Bool]] {
        return MovingFigure.num2fig(num: self.number)
    }
    
    
    //将图形扩展为大小与游戏界面同样大小的图形
    func extendfig() -> [[Bool]] {
        //初始化空游戏界面，不需要地板
        var extend_movingfigure:[[Bool]] = Array(repeating:Array(repeating:false, count:self.gamecolumn), count:self.gamerow)
        //使用两个for循环的嵌套实现扩展
        for r in 0...(self.movingfigure().count - 1) {
            for c in 0...(self.movingfigure()[0].count - 1) {
                extend_movingfigure[self.y+r][self.x+c] = MovingFigure.num2fig(num: self.number)[r][c]
            }
        }
        return extend_movingfigure
    }
    
    //执行旋转的函数
    func turn() {
        switch self.number {
        case 1:
            self.number = 2
        case 2:
            self.number = 1
        case 3:
            self.number = 4
        case 4:
            self.number = 3
        case 5:
            self.number = 6
        case 6:
            self.number = 7
        case 7:
            self.number = 8
        case 8:
            self.number = 5
        case 9:
            self.number = 10
        case 10:
            self.number = 11
        case 11:
            self.number = 12
        case 12:
            self.number = 9
        case 14:
            self.number = 15
        case 15:
            self.number = 14
        case 16:
            self.number = 17
        case 17:
            self.number = 18
        case 18:
            self.number = 19
        case 19:
            self.number = 16
        default: break
        }
         self.x = MovingFigure.legalize_x(number: self.number, x: self.x, gamecolumn: self.gamecolumn)
        self.y = MovingFigure.legalize_y(number: self.number, y: self.y, gamerow: self.gamerow)
    }
    
    
    //x+1
    func increase_x() {
        self.x = MovingFigure.legalize_x(number: self.number, x: self.x+1, gamecolumn: self.gamecolumn)
    }
    //x-1
    func decrease_x() {
        self.x = MovingFigure.legalize_x(number: self.number, x: self.x-1, gamecolumn: self.gamecolumn)
    }
    //y+1
    func increase_y() {
        self.y = MovingFigure.legalize_y(number: self.number, y: self.y+1, gamerow: self.gamerow)
    }
    
    //输出扩展后的图形（用于调试）
    func show() {
        for i in 0...(self.extendfig().count-1){
            for j in self.extendfig()[i]{
                if j {
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
