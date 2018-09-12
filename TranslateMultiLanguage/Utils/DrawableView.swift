//
//  DrawableView.swift
//  Translate_cn-vi
//
//  Created by Anh Son Le on 6/29/18.
//  Copyright © 2018 stadio. All rights reserved.
//

import UIKit

class DrawPoint {
    
    init(point: CGPoint, time: Double) {
        self.x = point.x
        self.y = point.y
        self.time = Int(time * 1000)
    }
    
    var x: CGFloat = 0
    var y: CGFloat = 0
    var time: Int = 0
}

class DrawableView: UIView {
    
    let path=UIBezierPath()
    var previousPoint:CGPoint
    var lineWidth:CGFloat=5.0
    var paths: [[DrawPoint]] = [[DrawPoint]()]
    var currentPath: [DrawPoint] = []
    var timeBeginDraw: Double = 0
    
    var delegate: DrawableViewDelegate?
    
    override init(frame: CGRect) {
        previousPoint=CGPoint.zero
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        previousPoint=CGPoint.zero
        super.init(coder: aDecoder)!
        let panGestureRecognizer=UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGestureRecognizer.maximumNumberOfTouches=1
        self.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        UIColor.darkGray.setStroke()
        path.stroke()
        path.lineWidth=lineWidth
    }
    
    @objc func pan(panGestureRecognizer:UIPanGestureRecognizer)->Void
    {
        
        if timeBeginDraw == 0 {
            timeBeginDraw = Date().timeIntervalSince1970
            paths.removeAll()
            delegate?.willBeginDraw?()
        }
        
        let currentPoint=panGestureRecognizer.location(in: self)
        let midPoint=self.midPoint(p0: previousPoint, p1: currentPoint)
        
        if panGestureRecognizer.state == .began
        {
            path.move(to: currentPoint)
            let point = DrawPoint.init(point: currentPoint, time: Date().timeIntervalSince1970 - timeBeginDraw)
            currentPath.append(point)
        }
        else if panGestureRecognizer.state == .changed
        {
            path.addQuadCurve(to: midPoint,controlPoint: previousPoint)
            let point = DrawPoint.init(point: midPoint, time: Date().timeIntervalSince1970 - timeBeginDraw)
            currentPath.append(point)
            
        } else if panGestureRecognizer.state == .ended {
            self.paths.append(currentPath)
            delegate?.didEndDraw?()
            currentPath.removeAll()
        }
        
        previousPoint=currentPoint
        self.setNeedsDisplay()
    }
    
    func midPoint(p0:CGPoint,p1:CGPoint)->CGPoint
    {
        let x=(p0.x+p1.x)/2
        let y=(p0.y+p1.y)/2
        return CGPoint(x: x, y: y)
    }
    
    func clearBoard() {
        timeBeginDraw = 0
        previousPoint=CGPoint.zero
        path.removeAllPoints()
        paths.removeAll()
        currentPath.removeAll()
        setNeedsDisplay()
    }

}

extension DrawableView {
    func printPath(path:[DrawPoint]) -> [[Double]] {
        let xPoints = path.map({Double($0.x)})
        let yPoints = path.map({Double($0.y)})
        let times = path.map({Double($0.time)})
        self.frame.minX
        return([xPoints, yPoints, times])
    }
    
    func convertPaths() -> [[[Double]]] {
        var res: [[[Double]]] = [[[]]]
        res.removeAll()
        for path in paths {
            res.append(printPath(path: path))
        }
        return res
    }
}

@objc protocol DrawableViewDelegate {
    @objc optional func willBeginDraw()
    @objc optional func didEndDraw()
}
