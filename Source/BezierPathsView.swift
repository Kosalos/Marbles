import UIKit

class BezierPathsView: UIView {
    
    fileprivate var bezierPaths = [String:UIBezierPath]()
    fileprivate var barrier = Array<CGPoint>()
    fileprivate var lastTouch:CGPoint = CGPoint(x: 0,y: 0)
    
    func setPath(_ path: UIBezierPath?,named name:String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.red.setStroke()
        UIColor.yellow.setFill()
        for(_,path) in bezierPaths {
            
            path.lineWidth = 2.0
            path.fill()
            path.stroke()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            lastTouch = touch.location(in: self)
            //print(NSString(format:"Began %.0f,%.0f",lastTouch.x,lastTouch.y), appendNewline: true)
            
            barrier.removeAll()
            barrier.append(lastTouch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //print(NSString(format:"Moved %.0f,%.0f",location.x,location.y), appendNewline: true)
            
            if(hypot(location.x-lastTouch.x,location.y-lastTouch.y) > 30) {
                lastTouch = location
                barrier.append(lastTouch)
                dropItBehavior.calculateBarrier(barrier, named:"User", pathView:self)
            }
        }
    }
}
