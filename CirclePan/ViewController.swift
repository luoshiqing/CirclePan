//
//  ViewController.swift
//  CirclePan
//
//  Created by sqluo on 2017/3/14.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit

let SCREENWIDTH = UIScreen.main.bounds.width
let SCREENHEIGHT = UIScreen.main.bounds.height

func DIST(pointA: CGPoint, pointB: CGPoint) -> CGFloat{
    
    let x = pow((pointA.x - pointB.x), 2)
    let y = pow((pointA.y-pointB.y), 2)
    
    let b = sqrt(x + y)
    
    return b
}
let MENURADIUS = SCREENWIDTH * 0.5
let PROPORTION: CGFloat = 0.45




class ViewController: UIViewController {

    
    
    
    var content: UIView!
    var viewArray: [UIView]!
    var circleView: UIImageView!
    
    
    var beginPoint = CGPoint(x: 0, y: 0)
    var orgin = CGPoint(x: 0, y: 0)
    var a: CGFloat = 0
    var b: CGFloat = 0
    var c: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        let circle = CirclePanView(frame: CGRect(x: 100, y: 100, width: 250, height: 250), centerImg: "circle", imgArray: self.getImgArray()) { (index) in
            print(index)
        }
//        circle.center = self.view.center
        self.view.addSubview(circle)
        
        
        
//        self.initSomeView()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getImgArray() -> [imgModel]{
        var imgArray = [imgModel]()
        for i in 1...8 {
            let model = imgModel(img: "\(i)", name: "\(i)")
            imgArray.append(model)
        }
        return imgArray
    }
    
    
    func initSomeView(){
        
        var imgArray = [imgModel]()
        for i in 1...8 {
            let model = imgModel(img: "\(i)", name: "\(i)")
            imgArray.append(model)
        }
        
        
        let bgImg = UIImageView(frame: self.view.bounds)
        bgImg.image = UIImage(named: "main")
        self.view.addSubview(bgImg)
        
        
        content = UIView(frame: CGRect(x: 0, y: 0.17 * SCREENHEIGHT, width: SCREENWIDTH, height: SCREENWIDTH))
        
        content.backgroundColor = UIColor.red
        //        content.center = self.view.center
        self.view.addSubview(content)
        
        
        let wid = content.frame.width * PROPORTION - 20
        
        circleView = UIImageView(frame: CGRect(x: 0, y: 0, width: wid, height: wid))
        circleView.center = CGPoint(x: content.frame.width / 2, y: content.frame.height / 2)
        circleView.image = UIImage(named: "circle")
        
        content.addSubview(circleView)
    }
    
    
    
    
    
    func touchPointInsideCircle(center: CGPoint, radius: CGFloat, targetPoint: CGPoint) ->Bool {
        let dist = DIST(pointA: targetPoint, pointB: center)
        return dist <= radius
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let p = touches.first!.location(in: self.view)
//        self.beginPoint = p
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        orgin = CGPoint(x: 0.5 * SCREENWIDTH, y: MENURADIUS + 0.17 * SCREENHEIGHT)
//        
//        print("orgin:\(orgin)")
//        
//        let p = CGPoint(x: self.content.frame.width/2, y: self.content.frame.height/2)
//        
//        print("----------p:\(p)")
//        
//        
//        let currentP = touches.first!.location(in: self.view)
//        
//        let dist = self.touchPointInsideCircle(center: orgin, radius: self.content.frame.width / 2, targetPoint: currentP)
//        
//        if dist{
//            
//            b = DIST(pointA: beginPoint, pointB: orgin)
//            c = DIST(pointA: currentP, pointB: orgin)
//            a = DIST(pointA: beginPoint, pointB: currentP)
//            
//            let angleBegin = atan2(beginPoint.y - orgin.y, beginPoint.x - orgin.x)
//            let angleAfter = atan2(currentP.y - orgin.y, currentP.x - orgin.x)
//            let angle = angleAfter - angleBegin
//            
////            print(angle)
//            
//            self.content.transform = CGAffineTransform(rotationAngle: angle)
//            
////            beginPoint = currentP
//        }
    
        
        
//    }
    

}

