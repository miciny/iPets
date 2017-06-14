//
//  ElementsView.swift
//  Tetris
//
//  Created by maocaiyuan on 2017/1/23.
//  Copyright © 2017年 maocaiyuan. All rights reserved.
//

import UIKit

class TetrisElementsModules: NSObject {
    
    var centerPointNo = 0  //中心
    fileprivate var ele: TetrisElementsObj!
    
    //获取元素
    func getView(_ type: Int) -> TetrisElementsObj{
        
        switch type {
        case 1:
            self.ele = self.tianView()  //田
        case 2:
            self.ele = self.rightZView()  //右z
        case 3:
            self.ele = self.leftZView()  //右z
        case 4:
            self.ele = self.tuView()  //土
        case 5:
            self.ele = self.leftLView()  //左L
        case 6:
            self.ele = self.rightLView()  //右L
        case 7:
            self.ele = self.zheView()  //折
        case 8:
            self.ele = self.dotView()  //点
        case 9:
            self.ele = self.bankuangView()  //半框
        case 10:
            self.ele = self.bigTuView()  //大土
        case 11:
            self.ele = self.I3View()  //条 3个
        case 12:
            self.ele = self.bigShanView()  //大山
        case 13:
            self.ele = self.bigbigShanView()  //大大山
        case 14:
            self.ele = self.bigKuangView()  //大框
        case 15:
            self.ele = self.HView()  //H
        case 16:
            self.ele = self.shiziView()  //十字
        case 17:
            self.ele = self.miView()  //米字
        case 18:
            self.ele = self.halfmiView()  //半米子
        case 19:
            self.ele = self.xie4View()  //斜4
        case 20:
            self.ele = self.xie3View()  //斜3
        case 21:
            self.ele = self.F1View()  //f1
        case 22:
            self.ele = self.F2View()  //f2 颜色不一样
        case 23:
            self.ele = self.I2View()  //i2
        case 24:
            self.ele = self.I5View()  //i5 
        default:
            self.ele = self.I4View()  //竖条 4个
        }
        
        return self.ele
    }
    
    //获取转的方法
    func getTurnedView(_ element: [[Int]], dir: Int, wcount: Int) -> [[Int]]{
        
        let ceter = self.ele.ceterPonintNo
        if self.ele.dirNo == TetrisDirModules.four {
            return self.theTransFunc4Dir(ceter!, point: element, count: wcount)
        }else if self.ele.dirNo == TetrisDirModules.two{
            return self.theTransFunc2Dir(ceter!, point: element, count: wcount, dir: dir)
        }else{
            return element
        }
    }
    
    //判断边界时，返回要判断的点，每个类型判断的点不一样
    
    //根据上下左右是不是自己，来返回是否要检测
    func checkPoint(_ ele: [[Int]], checkDir: Int) -> [[Int]]{
        let eleArray = NSMutableArray()
        eleArray.addObjects(from: ele)
        
        var checkPoint = [[Int]]()
        var eT = [-1, -1]
        
        for e in ele {
            switch checkDir {
            case 1: //左
                eT = [e[0]-1, e[1]]
            case 2: //右
                eT = [e[0]+1, e[1]]
            default: //下
                eT = [e[0], e[1]+1]
            }
            
            if !eleArray.contains(eT) {
                checkPoint.append(e)
            }
        }
        
        return checkPoint
    }
    
//===变化方法=============================================================================
    // 4个方向的变化的公式：土 L
    fileprivate func theTransFunc4Dir(_ centerNo: Int, point: [[Int]], count: Int) -> [[Int]]{
        var point = point
        let pcenter = point[centerNo]
        for i in 0 ..< point.count{
            if point[i] != pcenter {
                let a = point[i][0]
                let b = point[i][1]
                let x = pcenter[0]
                let y = pcenter[1]
                
                if a == x{ //x相同
                    point[i][0] = a + y - b
                    point[i][1] = y
                }else if b == y{  //y相同
                    point[i][1] = b - x + a
                    point[i][0] = x
                }else if a != x && b != y{ //都不同 则是转90度
                    let xDlt = a - x
                    let yDlt = b - y
                    
                    point[i][0] = x - yDlt
                    point[i][1] = y + xDlt
                }
            }
        }
        
        //偏差，变换时可能超出范围
        let dlt = self.calculateTheDlt(point, wcount: count)
        for i in 0 ..< point.count{
            point[i][0] = point[i][0] + dlt
        }
        
        return point
    }
    
    // 2个方向的变化的公式：竖条 Z
    fileprivate func theTransFunc2Dir(_ centerNo: Int, point: [[Int]], count: Int, dir: Int) -> [[Int]]{
        var point = point
        let pcenter = point[centerNo]
        var dirT = 1
        
        switch dir {
        case 0, 2:
            dirT = 1
        default:
            dirT = -1
        }
        
        for i in 0 ..< point.count{
            if point[i] != pcenter {
                let a = point[i][0]
                let b = point[i][1]
                let x = pcenter[0]
                let y = pcenter[1]
                
                if a == x{ //x相同
                    point[i][0] = a + (y - b) * dirT
                    point[i][1] = y
                }else if b == y{  //y相同
                    point[i][1] = b - (x - a) * dirT
                    point[i][0] = x
                }else if a != x && b != y{ //都不同 则是转90度
                    let xDlt = a - x
                    let yDlt = b - y
                    
                    if dirT == 1 {
                        point[i][0] = x - yDlt
                        point[i][1] = y + xDlt
                    }else{
                        point[i][0] = x + yDlt
                        point[i][1] = y - xDlt
                    }
                }
            }
        }
        
        //偏差，变换时可能超出范围
        let dlt = self.calculateTheDlt(point, wcount: count)
        for i in 0 ..< point.count{
            point[i][0] = point[i][0] + dlt
        }
        
        return point
    }
    
    //变化时超出范围的
    fileprivate func calculateTheDlt(_ point: [[Int]], wcount: Int) -> Int{
        var dlt = 0
        var pTemp = [Int]()
        for p in point {
            pTemp.append(p[0])
        }
        
        let pT = pTemp.sorted(by: tetrisGetSort)
        
        let min = pT.first!
        let max = pT.last!
        if min < 0{
            dlt = -min
        }else if max >= wcount{
            dlt = wcount-max-1
        }
        return dlt
    }
    
    
    
//===I40=============================================================================
    fileprivate func I4View() -> TetrisElementsObj{
        let point = [[centerPointNo, 0],
                     [centerPointNo, 1],
                     [centerPointNo, 2],
                     [centerPointNo, 3]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 1,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele0Color)
        return pointModule
    }
    

//===田1=============================================================================
    fileprivate func tianView() -> TetrisElementsObj{
        let point = [[centerPointNo-1, 0], [centerPointNo, 0],
                     [centerPointNo-1, 1], [centerPointNo, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 0,
                                      dirNo: TetrisDirModules.no, eleFunction: TetrisEleFunction.nothing, color: ele1Color)
        return pointModule
    }
    
//===右z2=============================================================================
    fileprivate func rightZView() -> TetrisElementsObj{
        let point = [[centerPointNo-1, 0],
                     [centerPointNo-1, 1], [centerPointNo, 1],
                     [centerPointNo, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 1,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele2Color)
        return pointModule
    }
    
//===左z3=============================================================================
    fileprivate func leftZView() -> TetrisElementsObj{
        let point = [[centerPointNo, 0],
                     [centerPointNo, 1], [centerPointNo-1, 1],
                     [centerPointNo-1, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 1,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele3Color)
        return pointModule
    }
    
//===土4=============================================================================
    fileprivate func tuView() -> TetrisElementsObj {
        let point = [[centerPointNo, 0],
                     [centerPointNo-1, 1], [centerPointNo, 1], [centerPointNo+1, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 2,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele4Color)
        return pointModule
    }
    
    
    
//===左L5=============================================================================
    fileprivate func leftLView() -> TetrisElementsObj {
        let point = [[centerPointNo, 0],
                     [centerPointNo, 1],
                     [centerPointNo, 2], [centerPointNo-1, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 2,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele5Color)
        return pointModule
    }
    
//===右L6=============================================================================
    fileprivate func rightLView() -> TetrisElementsObj {
        let point = [[centerPointNo, 0],
                     [centerPointNo, 1],
                     [centerPointNo, 2], [centerPointNo+1, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 2,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele6Color)
        return pointModule
    }
    
//===折7=============================================================================
    fileprivate func zheView() -> TetrisElementsObj {
        let point = [[centerPointNo, 0],
                     [centerPointNo, 1], [centerPointNo-1, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 1,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele7Color)
        return pointModule
    }
    
//===点8=============================================================================
    fileprivate func dotView() -> TetrisElementsObj {
        let point = [[centerPointNo, 0]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 0,
                                      dirNo: TetrisDirModules.no, eleFunction: TetrisEleFunction.invisible, color: ele8Color)
        return pointModule
    }
    
//===半框9=============================================================================
    fileprivate func bankuangView() -> TetrisElementsObj {
        let point = [[centerPointNo-1, 0], [centerPointNo+1, 0],
                     [centerPointNo-1, 1], [centerPointNo, 1], [centerPointNo+1, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 3,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele9Color)
        return pointModule
    }
    
//===大土10=============================================================================
    fileprivate func bigTuView() -> TetrisElementsObj {
        let point = [[centerPointNo, 0],
                     [centerPointNo, 1],
                     [centerPointNo-1, 2], [centerPointNo, 2], [centerPointNo+1, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 3,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele10Color)
        return pointModule
    }
    
//===I311=============================================================================
    fileprivate func I3View() -> TetrisElementsObj{
        let point = [[centerPointNo, 0],
                     [centerPointNo, 1],
                     [centerPointNo, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 1,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele11Color)
        return pointModule
    }
    
//===大山12=============================================================================
    fileprivate func bigShanView() -> TetrisElementsObj{
        let point = [[centerPointNo-2, 0], [centerPointNo, 0], [centerPointNo+2, 0],
                     [centerPointNo-2, 1],[centerPointNo-1, 1], [centerPointNo, 1],[centerPointNo+1, 1], [centerPointNo+2, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 5,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele12Color)
        return pointModule
    }
    
//===大大山13=============================================================================
    fileprivate func bigbigShanView() -> TetrisElementsObj{
        let point = [[centerPointNo-2, 0], [centerPointNo+2, 0],
                     [centerPointNo-2, 1],[centerPointNo, 1],[centerPointNo+2, 1],
                     [centerPointNo-2, 2],[centerPointNo, 2], [centerPointNo+2, 2],
                     [centerPointNo-2, 3], [centerPointNo-1, 3],[centerPointNo, 3],[centerPointNo+1, 3],[centerPointNo+2, 3]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 10,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele13Color)
        return pointModule
    }
    
//===大筐14=============================================================================
    fileprivate func bigKuangView() -> TetrisElementsObj{
        let point = [[centerPointNo-1, 0], [centerPointNo+1, 0],
                     [centerPointNo-1, 1],[centerPointNo+1, 1],
                     [centerPointNo-1, 2], [centerPointNo, 2],[centerPointNo+1, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 5,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele14Color)
        return pointModule
    }
    
//===H15=============================================================================
    fileprivate func HView() -> TetrisElementsObj{
        let point = [[centerPointNo-1, 0], [centerPointNo+1, 0],
                     [centerPointNo-1, 1],[centerPointNo, 1],[centerPointNo+1, 1],
                     [centerPointNo-1, 2],[centerPointNo+1, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 3,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele15Color)
        return pointModule
    }
    
//===十字16=============================================================================
    fileprivate func shiziView() -> TetrisElementsObj{
        let point = [[centerPointNo, 0],
                     [centerPointNo-1, 1],[centerPointNo, 1],[centerPointNo+1, 1],
                     [centerPointNo, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 2,
                                      dirNo: TetrisDirModules.no, eleFunction: TetrisEleFunction.nothing, color: ele16Color)
        return pointModule
    }
    
//===米字17=============================================================================
    fileprivate func miView() -> TetrisElementsObj{
        let point = [[centerPointNo-1, 0],[centerPointNo+1, 0],
                     [centerPointNo, 1],
                     [centerPointNo-1, 2],[centerPointNo+1, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 2,
                                      dirNo: TetrisDirModules.no, eleFunction: TetrisEleFunction.boom, color: ele17Color)
        return pointModule
    }
    
//===半米字18=============================================================================
    fileprivate func halfmiView() -> TetrisElementsObj{
        let point = [[centerPointNo, 0],
                     [centerPointNo-1, 1],[centerPointNo+1, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 0,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele18Color)
        return pointModule
    }
    
//===斜的4个19=============================================================================
    fileprivate func xie4View() -> TetrisElementsObj{
        let point = [[centerPointNo+1, 0],
                     [centerPointNo, 1],
                     [centerPointNo-1, 2],
                     [centerPointNo-2, 3]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 2,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele19Color)
        return pointModule
    }
    
//===斜的3个20=============================================================================
    fileprivate func xie3View() -> TetrisElementsObj{
        let point = [[centerPointNo+1, 0],
                     [centerPointNo, 1],
                     [centerPointNo-1, 2]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 1,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele20Color)
        return pointModule
    }
    
//===21F1 =============================================================================
    fileprivate func F1View() -> TetrisElementsObj{
        let point = [[centerPointNo-2, 0], [centerPointNo, 0],
                     [centerPointNo-2, 1],[centerPointNo-1, 1], [centerPointNo, 1],[centerPointNo+1, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 3,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele21Color)
        return pointModule
    }
    
//颜色不一样===22F2 =============================================================================
    fileprivate func F2View() -> TetrisElementsObj{
        let point = [[centerPointNo-2, 0], [centerPointNo-1, 0], [centerPointNo, 0], [centerPointNo+1, 0],
                     [centerPointNo-1, 1],[centerPointNo+1, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 2,
                                      dirNo: TetrisDirModules.four, eleFunction: TetrisEleFunction.nothing, color: ele22Color)
        return pointModule
    }
    
//===I2 23=============================================================================
    fileprivate func I2View() -> TetrisElementsObj{
        let point = [[centerPointNo, 0],
                     [centerPointNo, 1]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 0,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele23Color)
        return pointModule
    }
    
//===I5 24=============================================================================
    fileprivate func I5View() -> TetrisElementsObj{
        let point = [[centerPointNo-2, 0],[centerPointNo-1, 0],[centerPointNo, 0],[centerPointNo+1, 0],[centerPointNo+2, 0]]
        let pointModule = TetrisElementsObj(elePoint: point, ceterPonintNo: 2,
                                      dirNo: TetrisDirModules.two, eleFunction: TetrisEleFunction.nothing, color: ele24Color)
        return pointModule
    }
}
