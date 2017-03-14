//
//  CirclePanView.swift
//  CirclePan
//
//  Created by sqluo on 2017/3/14.
//  Copyright © 2017年 sqluo. All rights reserved.
//

import UIKit

struct imgModel {
    var img : String
    var name: String
}

class CirclePanView: UIView {

    //中心图片
    fileprivate var circleImgView: UIImageView?
    
    //中心图片跟父视图的大小比例
    fileprivate let pro: CGFloat = 0.28
    //周边图片是父视图的大小比例
    fileprivate let somePro: CGFloat = 0.21
    
    //三边
    fileprivate var a: CGFloat = 0
    fileprivate var b: CGFloat = 0
    fileprivate var c: CGFloat = 0
    fileprivate var orgin = CGPoint(x: 0, y: 0) //旋转的中心点
    fileprivate var beginPoint: CGPoint! //开始点击的点
    
    //是否点击的是区域内
    fileprivate var isInside = true
    
    //中心图片名称
    fileprivate var centerImg: String!
    
    //存放周边图片视图数组
    fileprivate var someImgArray = [UIImageView]()
    
    fileprivate var touchHandle: ((Int)->())?
    
    init(frame: CGRect, centerImg: String, imgArray: [imgModel], touchHandle: @escaping (Int)->()) {
        super.init(frame: frame)
        
        self.touchHandle = touchHandle
        
        self.centerImg = centerImg
        
        self.backgroundColor = UIColor.yellow
        
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        
        self.initCircleImgView()
        self.rotationCircle(center: CGPoint(x: self.frame.width/2, y: self.frame.height/2), radius: self.frame.width / 3, model: imgArray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initCircleImgView(){
        let w = self.frame.width * pro
        circleImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: w, height: w))
        circleImgView?.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        circleImgView?.image = UIImage(named: self.centerImg)
        
        circleImgView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.someImgAct(_:)))
        circleImgView?.tag = -1
        circleImgView?.addGestureRecognizer(tap)
        
        self.addSubview(circleImgView!)
        
        
    }
    
    
    func rotationCircle(center: CGPoint, radius: CGFloat,model: [imgModel]){
        
        for i in 0..<model.count {
            
            let index = CGFloat(M_PI * 2) / CGFloat(model.count) * CGFloat(i)
            
            let x = radius * sin(index) + self.frame.width / 2
            let y = radius * cos(index) + self.frame.width / 2
            

            
            let imgV = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width * somePro, height: self.frame.width * somePro))
            imgV.center = CGPoint(x: x, y: y)
            imgV.tag = i
            
            imgV.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.someImgAct(_:)))
            imgV.addGestureRecognizer(tap)
            
            imgV.image = UIImage(named: model[i].img)
            
            self.addSubview(imgV)
            
            self.someImgArray.append(imgV)
        }
        
    }
    
    func someImgAct(_ send: UITapGestureRecognizer){
                
        self.touchHandle?(send.view!.tag)
        
        if send.view!.tag == -1 {
            self.close()
        }
    }
    
    
    func close(){
        
//        for i in 0..<self.someImgArray.count {
//            let img = self.someImgArray[i]
//            
//            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
//                img.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
//                img.alpha = 0
//            }, completion: { (isOK) in
//                
//                print("动画完成")
//                
//            })
//            
//            
//        }
        
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            
            for i in 0..<self.someImgArray.count {
                let img = self.someImgArray[i]
                
                img.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
                img.alpha = 0
            }
            
            
        }, completion: { (isOK) in
            
            print("动画完成")
            
            self.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
            
        })
        
        
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let p = touches.first!.location(in: self.superview!)
        //print("开始点-->:\(p)")
        
        self.beginPoint = p
        
        
        
        let dist = self.touchPointInsideCircle(center: self.center, radius: self.frame.width/2, targetPoint: p)
        
        if dist{
            self.isInside = true
        }else{
            self.isInside = false
        }
    }
    
    var ang: CGFloat = 0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        orgin = self.center
        
        if self.isInside {
            
            let cp = touches.first!.location(in: self.superview!)

            a = DIST(pointA: beginPoint, pointB: cp)
            b = DIST(pointA: beginPoint, pointB: orgin)
            c = DIST(pointA: cp, pointB: orgin)
            
            let angleBegin = atan2(beginPoint.y-orgin.y, beginPoint.x-orgin.x)
            let angleAfter = atan2(cp.y-orgin.y, cp.x-orgin.x)
            
            let angle = angleAfter - angleBegin
            
            self.transform = CGAffineTransform(rotationAngle: angle + self.ang)
            self.circleImgView?.transform = CGAffineTransform(rotationAngle: -(angle + self.ang))
            for i in 0..<self.someImgArray.count {
                self.someImgArray[i].transform = CGAffineTransform(rotationAngle: -(angle + self.ang))
            }
            
            
        }
   
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.isInside{
            
            let cp = touches.first!.location(in: self.superview!)
            
            a = DIST(pointA: beginPoint, pointB: cp)
            b = DIST(pointA: beginPoint, pointB: orgin)
            c = DIST(pointA: cp, pointB: orgin)
            
            let angleBegin = atan2(beginPoint.y-orgin.y, beginPoint.x-orgin.x)
            let angleAfter = atan2(cp.y-orgin.y, cp.x-orgin.x)
            let angle = angleAfter - angleBegin
            
            self.ang += angle
        }
        
        
    }
    
    
    func touchPointInsideCircle(center: CGPoint, radius: CGFloat, targetPoint: CGPoint) ->Bool {
        let dist = DIST(pointA: targetPoint, pointB: center)
        return dist <= radius
    }
}
