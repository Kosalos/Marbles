import UIKit

class DropItBehavior: UIDynamicBehavior
{
    lazy var gravity: UIGravityBehavior = {
        let z = UIGravityBehavior()
        z.magnitude = 0.1
        return z
        }()
    
    lazy var collider: UICollisionBehavior = {
        let z = UICollisionBehavior()
        z.translatesReferenceBoundsIntoBoundary = false
        return z
        }()
    
    lazy var dropBehavior : UIDynamicItemBehavior = {
        let z = UIDynamicItemBehavior()
        z.allowsRotation = false
        z.elasticity = 0.37
        return z
        }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(dropBehavior)
    }
    
    func addBarrier(_ path: UIBezierPath, named name:String) {
        collider.removeBoundary(withIdentifier: name as NSCopying)
        collider.addBoundary(withIdentifier: name as NSCopying, for: path)
    }
    
    func addDrop(_ drop :UIView) {
        dynamicAnimator?.referenceView?.addSubview(drop)
        gravity.addItem(drop)
        collider.addItem(drop)
        dropBehavior.addItem(drop)
    }
    
    func removeDrop(_ drop: UIView) {
        gravity.removeItem(drop)
        collider.removeItem(drop)
        dropBehavior.removeItem(drop)
        drop.removeFromSuperview()
    }
    
    func calculateBarrier(_ path: Array<CGPoint>, named name:String, pathView view:BezierPathsView)  {
        if(path.count < 2) { return }
        
        let width = 2.0
        let offset: double_t = Double.pi/2.0
        let bp = UIBezierPath()
        var pt:CGPoint = CGPoint(x: 0.0,y: 0.0)
        var angle: double_t = 0
        var i = 0
        
        func calcPt(_ i1:Int,i2:Int) {
            angle = double_t(atan2(path[i1].y - path[i2].y,path[i1].x - path[i2].x)) - offset
            pt.x = path[i2].x + CGFloat(cos(angle) * width)
            pt.y = path[i2].y + CGFloat(sin(angle) * width)
            
            if(i2 == 0) {
                bp.move(to: pt)
            }
            else {
                bp.addLine(to: pt)
            }
        }
        func calcEndOfLinePt(_ i1:Int) {
            pt.x = path[i1].x + CGFloat(cos(angle) * width)
            pt.y = path[i1].y + CGFloat(sin(angle) * width)
            
            bp.addLine(to: pt)
        }
        
        repeat { calcPt(i+1,i2:i);  i += 1} while(i < path.count-1)
        calcEndOfLinePt(i)
        
        repeat { calcPt(i-1,i2:i); i -= 1 } while(i > 0)
        calcEndOfLinePt(i)
        
        bp.close()
        
        addBarrier(bp, named:name)
        view.setPath(bp, named:name)
    }
}
