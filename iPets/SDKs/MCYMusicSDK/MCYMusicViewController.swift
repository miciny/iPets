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

    var musicView: MusicPlayView!
    var coverFlowView: CoverFlowView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpEles()
        setUpView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        musicView.stopCurrentState()
    }
    
    func setUpEles(){
        self.title = "音乐"
        self.view.backgroundColor = UIColor.white
    }
    
    func setUpView(){
        musicView = MusicPlayView(frame: self.view.frame)
        self.view.addSubview(musicView)
        
        let coverFlowViewFrame = CGRect(x: 0, y: 64, width: Width, height: Width)
        let addImages = NSMutableArray()
        for i in 0 ..< 15{
            if let image = UIImage(named: "icon_\(i)"){
                addImages.add(image)
            }
        }
        
        coverFlowView = CoverFlowView(frame: coverFlowViewFrame, andImages: addImages, sideImageCount: 3, sideImageScale: 0.68, middleImageScale: 0.9)
        self.view.addSubview(coverFlowView)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
