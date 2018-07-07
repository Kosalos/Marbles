import UIKit

let dropItBehavior = DropItBehavior()

class ViewController: UIViewController, UIDynamicAnimatorDelegate
{
    @IBOutlet weak var gameView: BezierPathsView!
    
    let BCOUNT = 100
    var balls = [UIView]()
    
    lazy var animator: UIDynamicAnimator = {
        let z = UIDynamicAnimator(referenceView: self.gameView)
        z.delegate = self
        return z
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(dropItBehavior)
        
        Timer.scheduledTimer(withTimeInterval:0.05, repeats:true) { timer in self.timerHandler() }
        
        for i:Int in 0...BCOUNT {
            balls.append(UIView())
            balls[i].backgroundColor = randomColor()
            balls[i].layer.cornerRadius = dropSize.width/2;
            balls[i].layer.borderColor = UIColor.black.cgColor
            balls[i].layer.borderWidth = 0.0;
        }
        
        drop()
    }
    
    // MARK: timerHandler
    
    var bAngle: [double_t] = [ 0,0,0,0,0,0 ]
    var bSpeed: [double_t] = [ 0.02,0.03,0.04,0.05,0.06,0.07 ]
    var bDistance: [double_t] = [ 400,340,280,230,150,60 ]
    var bWidth: [double_t] = [ 60,60,60,60,60,60 ]
    
    func timerHandler() {
        var i = 0
        
        repeat {
            var pt:CGPoint = CGPoint(x:gameView.bounds.midX, y:gameView.bounds.midY)
            var pt2:CGPoint = CGPoint(x: 0.0,y: 0.0)
            
            pt.x += CGFloat(cos(bAngle[i]) * bDistance[i])
            pt.y += CGFloat(sin(bAngle[i]) * bDistance[i])
            
            var p = Array<CGPoint>()
            
            var sideAngle = bAngle[i] + Double.pi/2.0
            pt2.x = pt.x + CGFloat(cos(sideAngle) * bWidth[i])
            pt2.y = pt.y + CGFloat(sin(sideAngle) * bWidth[i])
            p.append(pt2)
            
            sideAngle = bAngle[i] + Double.pi/4.0
            pt2.x = pt.x + CGFloat(cos(sideAngle) * bWidth[i] * 1.2)
            pt2.y = pt.y + CGFloat(sin(sideAngle) * bWidth[i] * 1.2)
            p.append(pt2)
            
            sideAngle = bAngle[i]
            pt2.x = pt.x + CGFloat(cos(sideAngle) * bWidth[i] * 1.75)
            pt2.y = pt.y + CGFloat(sin(sideAngle) * bWidth[i] * 1.75)
            p.append(pt2)
            
            sideAngle = bAngle[i] - Double.pi/4.0
            pt2.x = pt.x + CGFloat(cos(sideAngle) * bWidth[i] * 1.2)
            pt2.y = pt.y + CGFloat(sin(sideAngle) * bWidth[i] * 1.2)
            p.append(pt2)
            
            sideAngle = bAngle[i] - Double.pi/2.0
            pt2.x = pt.x + CGFloat(cos(sideAngle) * bWidth[i])
            pt2.y = pt.y + CGFloat(sin(sideAngle) * bWidth[i])
            p.append(pt2)
            
            let name:String = NSString(format:"Bucket%d",i) as String
            dropItBehavior.calculateBarrier(p, named:name, pathView:gameView)
            
            bAngle[i] += bSpeed[i]/3.0
            
            i += 1
        } while(i < 6)
        
        for i:Int in 0...BCOUNT {
            if(balls[i].frame.origin.y > gameView.bounds.height+50)  {
                dropItBehavior.removeDrop(balls[i])
                balls[i].frame.origin.x = 10.0 + CGFloat.random(Int(gameView.bounds.width-20.0))
                balls[i].frame.origin.y = -50 - CGFloat.random(300)
                balls[i].backgroundColor = randomColor()
                
                dropItBehavior.addDrop(balls[i])
            }
        }
    }
    
    // MARK:
    
    func dynamicAnimatorDidPause(_ animator: UIDynamicAnimator) {}
    
    var dropsPerRow = 30
    
    var dropSize: CGSize {
        let size = gameView.bounds.width / CGFloat(dropsPerRow)
        return CGSize(width: size, height: size)
    }
    
    func drop() {
        var i = 0
        repeat {
            balls[i].frame = CGRect(origin:CGPoint.zero, size:dropSize)
            balls[i].frame.origin.x = CGFloat.random(dropsPerRow) * dropSize.width
            
            balls[i].backgroundColor = UIColor.random
            dropItBehavior.addDrop(balls[i])
            i += 1
        } while(i < BCOUNT)
    }
}

private extension CGFloat {
    static func random(_ max:Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random()%5 {
        case 0 : return UIColor.green
        case 1 : return UIColor.blue
        case 2 : return UIColor.orange
        case 3 : return UIColor.red
        case 4 : return UIColor.purple
        default : return UIColor.black
        }
    }
}

func randomColor() -> UIColor {
    return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
}

