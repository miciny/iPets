//
//  NTESMusicViewController.swift
//  MostWanted
//
//  Created by maocaiyuan on 16/3/19.
//  Copyright © 2016年 maocaiyuan. All rights reserved.
//

/*
    用到了AVFoundation库
*/

import UIKit
import AVFoundation

class MCYMusicViewController: UIViewController {

    var MyMusicView: MusicPlayView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        MyMusicView!.stopCurrentState()
    }
    
    func setUpEles(){
        self.title = "音乐"
        self.view.backgroundColor = UIColor.white
    }
    
    func setUpView(){
        MyMusicView = MusicPlayView(frame: self.view.frame)
        self.view.addSubview(MyMusicView!)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
