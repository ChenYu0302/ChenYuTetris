//
//  ViewController.swift
//  ChenYu_Tetris
//
//  Created by FutureHub on 17/12/7.
//  Copyright © 2017年 Rowling. All rights reserved.
//

import UIKit



//MARK: 全局变量
// 基本数据
let SCREEN_W = UIScreen.main.bounds.width //屏幕宽
let SCREEN_H = UIScreen.main.bounds.height //屏幕高
let gamerow:Int = 19//游戏行数，最后一行是地板
let gamecolumn:Int = 12//游戏列数
let btn_WH:CGFloat = 70//底部按钮宽高
let buttonCount:Int = 4//按钮总
//主界面UI位置
let squareWH:CGFloat = CGFloat(0.85*SCREEN_W/CGFloat(gamecolumn))
let squareCornerRadius:CGFloat = squareWH*0.2
let x0position:CGFloat = (SCREEN_W-CGFloat(gamecolumn)*squareWH)/2
let y0position:CGFloat = (SCREEN_H-btn_WH-CGFloat(gamerow-1)*squareWH)/3
//下一个图形UI位置
let smallSquareWH:CGFloat = squareWH*0.5
let smallSquareCornerRadius:CGFloat = squareCornerRadius*0.5
let nextX0position:CGFloat = SCREEN_W/2
let nextY0position:CGFloat = CGFloat(gamerow+1)*squareWH
//分数
let socreLableHeight:CGFloat = 100
let scoreLableWidth:CGFloat = 100
let lableX0position:CGFloat = SCREEN_W/2 - scoreLableWidth
let lableY0position:CGFloat = CGFloat(gamerow)*squareWH



class ViewController: UIViewController {
    
    // MARK:类属性
    var nextFigure = MovingFigure(number: Int(arc4random()%19)+1 , y: 0, x: 0, gamerow: gamerow, gamecolumn: gamecolumn) //下一个下落的图形
    var currentFigure = MovingFigure(number: Int(arc4random()%19)+1 , y: 0, x: 4, gamerow: gamerow, gamecolumn: gamecolumn) //当前下落图形
    var staticFigure = StaticFigure(gamerow: gamerow , gamecolumn: gamecolumn)//已经下落的图形
    var activate:Bool = true    //决定游戏是否继续
    var reach2ground:Bool = false//判断底部是否触碰
    var timer:Timer?    //定时器
    var gameView:[[UIView]] = []//主界面的[[UIView]]，这里不可以写[[]]
    var nextFigureView:[[UIView]] = []//下个图形的[[UIView]]
    var scoreLable = UILabel() //得分标签
    var score:Int = 0//得分
    
    //MARK:主函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createButton()
        careteGameView()
        createNextFigureView()
        createScoreLable()
        self.updateGameView()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(autoDrop), userInfo: nil, repeats: true)//设置定时器具体循环内容
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)//启动循环
    }
    
    //    MARK: - 主循环，每隔一秒执行一次
    @objc func autoDrop() {
        //		自动下落
        
        //创建self.staticFigure和self.currentFigure的副本，用于判断下落是否合法
        let copyStaticFigure = StaticFigure(gamerow: gamerow, gamecolumn: gamecolumn)
        copyStaticFigure.staticfigure = self.staticFigure.staticfigure
        let copyCurrentFigure = MovingFigure(number: 1, y: 0, x: 0, gamerow: gamerow, gamecolumn: gamecolumn)
        copyCurrentFigure.number = self.currentFigure.number
        copyCurrentFigure.x = self.currentFigure.x
        copyCurrentFigure.y = self.currentFigure.y
        //currentFigure的副本y+1
        copyCurrentFigure.increase_y()
        if  copyStaticFigure.determineLegal(copyCurrentFigure: copyCurrentFigure) {
            // 如果下落允许，每隔一秒图形下落一格，更新游戏界面
            self.currentFigure.increase_y()
            print("自动下落")
        }
        else{
            // 如果下落不允许，则底部发生碰撞。为了能有1次循环间隔的时间左右滑动，
            if reach2ground {
                print("reach2ground为真，进行一系列更新操作")
                self.staticFigure.addMovingFigure(currentFigure: self.currentFigure)
                self.score +=  self.staticFigure.eliminate()
                self.currentFigure.number = self.nextFigure.number
                self.currentFigure.x = 4
                self.currentFigure.y = 0
                self.nextFigure = MovingFigure(number: Int(arc4random()%19)+1 , y: 0, x: 0, gamerow: gamerow, gamecolumn: gamecolumn)
                self.reach2ground = false
                
                //创建self.staticFigure和self.currentFigure的副本，用于判断游戏是否结束
                let copyStaticFigure = StaticFigure(gamerow: gamerow, gamecolumn: gamecolumn)
                copyStaticFigure.staticfigure = self.staticFigure.staticfigure
                let copyCurrentFigure = MovingFigure(number: 1, y: 0, x: 0, gamerow: gamerow, gamecolumn: gamecolumn)
                copyCurrentFigure.number = self.currentFigure.number
                copyCurrentFigure.x = self.currentFigure.x
                copyCurrentFigure.y = self.currentFigure.y
                self.activate = copyStaticFigure.determineLegal(copyCurrentFigure: copyCurrentFigure)
                if !activate{
                    self.timer?.invalidate()
                    self.timer = nil
                    print("游戏结束")
                    self.createEndButton()
                }
            }
            else{
                print("底部发生碰撞,更新reach2ground为真")
                self.reach2ground = true
            }
            
        }
        self.updateGameView()
    }
    
    
    //		MARK: - 更新游戏界面
    func updateGameView() {
        //更新主界面：创建一个暂时的StaticFigure，加上currentFigure，通过颜色的映射将颜色设置为game_view的颜色
        let tempStaticFigure = StaticFigure(gamerow: gamerow, gamecolumn: gamecolumn)
        tempStaticFigure.staticfigure = self.staticFigure.staticfigure
        tempStaticFigure.addMovingFigure(currentFigure: currentFigure)
        let tempBoolArr = tempStaticFigure.staticfigure
        for i in 0..<(gamerow-1) {
            for j in 0..<gamecolumn {
                self.gameView[i][j].backgroundColor = bool2color(x: tempBoolArr[i][j])
            }
        }
        //更新下一个图形View
        for i in 0...3 {
            for j in 0...3 {
                let tempNextFigure = MovingFigure(number: 1, y: 0, x: 0, gamerow: gamerow, gamecolumn: gamecolumn)
                tempNextFigure.number = self.nextFigure.number
                self.nextFigureView[i][j].backgroundColor = bool2color2(x: tempNextFigure.extendfig()[i][j])//此处使用extendfig()是为了保证索引都是0...3
            }
        }
        //更新分数
        self.scoreLable.text = "Score:\(self.score)"
        //输出
        print("更新游戏界面","x",self.currentFigure.x,"y",self.currentFigure.y)
    }
    
    
    //    MARK: - 创建按钮
    func createButton() {
        let margin = (SCREEN_W - CGFloat(btn_WH*CGFloat(buttonCount)))/CGFloat(buttonCount + 1)//间隔
        for i in 0..<buttonCount {
            let btn = UIButton(type: .custom)
            let imagename:[String] = ["left70","up70","down70","right70"]
            btn.setBackgroundImage(UIImage.init(named: imagename[i]), for: UIControl.State.normal) //背景图片
            btn.frame = CGRect(x: margin + (margin + btn_WH) * CGFloat(i), y: SCREEN_H - btn_WH, width: btn_WH, height: btn_WH)//设置btn的边框
            btn.addTarget(self, action:#selector(buttonClick(btn:)), for: UIControl.Event.touchUpInside)
            btn.tag = i + 1//当前UIButton的tag，实现了点击不同的for产生的UIButton会指向不同tag的view
            self.view.addSubview(btn)//将btn显示到view上
        }
    }
    
    //    MARK: 按钮点击动作
    @objc func buttonClick(btn:UIButton) {
        switch btn.tag {
        case 1:
            self.leftTurnDownRight(action: "left")
        case 2:
            self.leftTurnDownRight(action: "turn")
        case 3:
            self.leftTurnDownRight(action: "down")
        case 4:
            self.leftTurnDownRight(action: "right")
        default:
            break
        }
        self.updateGameView()
    }
    
    
    //    MARK: - 创建游戏主界面方块行列阵
    func careteGameView() {
        for i in 0..<(gamerow-1) {
            var current_row:[UIView] = []
            for j in 0..<gamecolumn{
                let square = UIView()//创建方块:UIView
                square.backgroundColor = bool2color(x:false)//设置方块初始颜色(假对应的颜色)
                square.layer.cornerRadius = squareCornerRadius//设置圆角
                square.frame = CGRect(x: x0position+CGFloat(j)*squareWH, y: y0position+CGFloat(i)*squareWH, width: squareWH, height: squareWH)//设置位置大小
                current_row.append(square)
            }
            gameView.append(current_row)//方块行列阵装入类属性game_view中
        }
        
        for i in 0..<(gamerow-1) {
            for j in 0..<gamecolumn {
                self.view.addSubview(gameView[i][j])//使用addSubview添加game_view到根view，game_view作为类属性方便修改颜色
            }
        }
        
    }
    
    //    MARK: - 创建下个图形方块行列阵
    func createNextFigureView() {
        for i in 0...3 {
            var current_row:[UIView] = []
            for j in 0...3 {
                let square = UIView()//创建方块:UIView
                square.backgroundColor = bool2color2(x:false)//设置方块初始颜色(假对应的颜色)
                square.layer.cornerRadius = smallSquareCornerRadius
                square.frame = CGRect(x: nextX0position+CGFloat(j)*smallSquareWH, y: nextY0position+CGFloat(i)*smallSquareWH, width: smallSquareWH, height: smallSquareWH)//设置位置大小
                current_row.append(square)
            }
            nextFigureView.append(current_row)//方块行列阵装入类属性game_view中
        }
        for i in 0...3 {
            for j in 0...3 {
                self.view.addSubview(nextFigureView[i][j])//使用addSubview添加game_view到根view，game_view作为类属性方便修改颜色
            }
        }
        
    }
    
    //    MARK: - 创建分数标签
    
    func createScoreLable() {
        // 右对齐
        self.scoreLable.frame = CGRect(x: lableX0position, y: lableY0position, width: scoreLableWidth, height: socreLableHeight)//设置frame
        self.scoreLable.text = "Score:\(self.score)"
        self.view.addSubview(self.scoreLable)
    }
    
    
    //    MARK: - 创建游戏结束按钮
    func createEndButton() {
        let endButton = UIButton(type: .custom)
        endButton.frame = CGRect(x: 0.2*SCREEN_W, y: 0.4*SCREEN_H, width: 0.6*SCREEN_W, height: 0.2*SCREEN_H)
        endButton.titleLabel?.numberOfLines = 2
        endButton.titleLabel?.adjustsFontForContentSizeCategory = true
        endButton.setTitle("Game Over :(....\nClick to Start a New Game", for: UIControl.State.normal)
        endButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        endButton.backgroundColor = UIColor(red: 0xFF/256, green: 0xFF/256, blue: 0xFF/256, alpha: 0.8)
        endButton.layer.cornerRadius = CGFloat(0.2*0.2*SCREEN_H)
        self.view.addSubview(endButton)
//        endButton.addTarget(self, action: #selector(createNewGame(btn:)), for: UIControlEvents.touchUpInside)
    }
    
//    @objc func createNewGame(btn:UIButton) {
//        self.score = 0
//        self.staticFigure = StaticFigure(gamerow: gamerow , gamecolumn: gamecolumn)
//    }
    
    //    MARK: - 设置真假对应的颜色
    func bool2color(x:Bool) -> UIColor {
        if x {
            return UIColor.init(red: 0xFF/256, green: 0x80/256, blue: 0xAB/256, alpha: 1)
        }//真位置为基佬粉
        else{
            return UIColor.init(red: 0x66/256, green: 0xCC/256, blue: 0xFF/256, alpha: 1)
        }//假位置为洛天依蓝
    }
    
    
    //    MARK: - 设置下一个图形真假对应的颜色
    func bool2color2(x:Bool) -> UIColor {
        if x {
            return UIColor.init(red: 0xFF/256, green: 0x80/256, blue: 0xAB/256, alpha: 1)
        }//真位置为基佬粉
        else{
            return UIColor.clear
        }//假位置为洛天依蓝
    }
    
    
    func leftTurnDownRight(action:String) {
        //创建self.staticFigure和self.currentFigure的副本
        let copyStaticFigure = StaticFigure(gamerow: gamerow, gamecolumn: gamecolumn)
        copyStaticFigure.staticfigure = self.staticFigure.staticfigure
        let copyCurrentFigure = MovingFigure(number: 1, y: 0, x: 0, gamerow: gamerow, gamecolumn: gamecolumn)
        copyCurrentFigure.number = self.currentFigure.number
        copyCurrentFigure.x = self.currentFigure.x
        copyCurrentFigure.y = self.currentFigure.y
        //对currentFigure副本操作
        if action == "left" {
            copyCurrentFigure.decrease_x()
        }
        if action == "turn" {
            copyCurrentFigure.turn()
        }
        if action == "down" {
            copyCurrentFigure.increase_y()
        }
        if action == "right" {
            copyCurrentFigure.increase_x()
        }
        //判断currentFigure副本与staticFigure是否合法
        let result:Bool = copyStaticFigure.determineLegal(copyCurrentFigure: copyCurrentFigure)
        if result {
            if action == "left" {
                self.currentFigure.decrease_x()
            }
            if action == "turn" {
                self.currentFigure.turn()
            }
            if action == "down" {
                self.currentFigure.increase_y()
            }
            if action == "right" {
                self.currentFigure.increase_x()
            }
            print("操作合法，没有碰撞")
        }
        else{
            print("操作不合法，发生碰撞")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
