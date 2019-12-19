//
//  DrawSignatureView.swift
//  DeliveryApp
//
//  Created by Khadija Daruwala on 19/12/19.
//  Copyright © 2019 Khadija Daruwala. All rights reserved.
//

import UIKit


@objc
public protocol DrawSignatureDelegate: class {
    func didStart(_ view : DrawSignatureView)
    func didFinish(_ view : DrawSignatureView)
}

@IBDesignable
final public class DrawSignatureView: UIView {
    
    public weak var delegate: DrawSignatureDelegate?
    
    // MARK: Public properties
    @IBInspectable public var strokeWidth: CGFloat = 2.0 {
        didSet {
            path.lineWidth = strokeWidth
        }
    }
    
    @IBInspectable public var strokeColor: UIColor = .black {
        didSet {
            if !path.isEmpty {
                strokeColor.setStroke()
            }
        }
    }
    
    @IBInspectable public var signatureBackgroundColor: UIColor = .white {
        didSet {
            backgroundColor = signatureBackgroundColor
        }
    }
    
    // MARK: Private properties
    fileprivate var path = UIBezierPath()
    fileprivate var points = [CGPoint](repeating: CGPoint(), count: 5)
    fileprivate var controlPoint = 0
    
    // MARK:  Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        path.lineWidth = strokeWidth
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        path.lineWidth = strokeWidth
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
    }
    
    // MARK: - Draw
    override public func draw(_ rect: CGRect) {
        self.strokeColor.setStroke()
        self.path.stroke()
    }
    
    // MARK: - Touch handling functions
    override public func touchesBegan(_ touches: Set <UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            controlPoint = 0
            points[0] = touchPoint
        }
        
        if let delegate = delegate {
            delegate.didStart(self)
        }
    }
    
    override public func touchesMoved(_ touches: Set <UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let touchPoint = firstTouch.location(in: self)
            controlPoint += 1
            points[controlPoint] = touchPoint
            if (controlPoint == 4) {
                points[3] = CGPoint(x: (points[2].x + points[4].x)/2.0, y: (points[2].y + points[4].y)/2.0)
                path.move(to: points[0])
                path.addCurve(to: points[3], controlPoint1: points[1], controlPoint2: points[2])
                
                setNeedsDisplay()
                points[0] = points[3]
                points[1] = points[4]
                controlPoint = 1
            }
            
            setNeedsDisplay()
        }
    }
    
    override public func touchesEnded(_ touches: Set <UITouch>, with event: UIEvent?) {
        if controlPoint < 4 {
            let touchPoint = points[0]
            path.move(to: CGPoint(x: touchPoint.x,y: touchPoint.y))
            path.addLine(to: CGPoint(x: touchPoint.x,y: touchPoint.y))
            setNeedsDisplay()
        } else {
            controlPoint = 0
        }
        
        if let delegate = delegate {
            delegate.didFinish(self)
        }
    }
    
    // MARK: - Methods for interacting with Signature View
    
    // Clear the Signature View
    public func clear() {
        self.path.removeAllPoints()
        self.setNeedsDisplay()
    }
    
    // Save the Signature as an UIImage
    public func getSignature(scale:CGFloat = 1) -> UIImage? {
        if !doesContainSignature { return nil }
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, scale)
        self.strokeColor.setStroke()
        self.path.stroke()
        let signature = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return signature
    }
    
    public var doesContainSignature: Bool {
        get {
            if path.isEmpty {
                return false
            } else {
                return true
            }
        }
    }
    
    func injectBezierPath(_ path: UIBezierPath) {
        self.path = path
    }
}


