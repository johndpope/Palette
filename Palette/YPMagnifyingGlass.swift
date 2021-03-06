//
//  YPMagnifyingGlass.swift
//  YPMagnifyingGlass
//
//  Created by Geert-Jan Nilsen on 02/06/15.
//  Copyright (c) 2015 Yuppielabel.com All rights reserved.
//

import UIKit
import QuartzCore

public class YPMagnifyingGlass: UIView {

  public var viewToMagnify: UIView!
  public var touchPoint: CGPoint! {
    didSet {
        self.center = CGPoint(x: touchPoint.x + touchPointOffset.x, y: touchPoint.y + touchPointOffset.y)
    }
  }
  
  public var touchPointOffset: CGPoint!
  public var scale: CGFloat!
  public var scaleAtTouchPoint: Bool!
  
  public var YPMagnifyingGlassDefaultRadius: CGFloat = 10.0
  public var YPMagnifyingGlassDefaultOffset: CGFloat = -60.0
  public var YPMagnifyingGlassDefaultScale: CGFloat = 10.0
  
  public func initViewToMagnify(viewToMagnify: UIView, touchPoint: CGPoint, touchPointOffset: CGPoint, scale: CGFloat, scaleAtTouchPoint: Bool) {
  
    self.viewToMagnify = viewToMagnify
    self.touchPoint = touchPoint
    self.touchPointOffset = touchPointOffset
    self.scale = scale
    self.scaleAtTouchPoint = scaleAtTouchPoint
  
  }

  required public convenience init(coder aDecoder: NSCoder) {
    self.init(coder: aDecoder)
  }
  
  required public override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
    self.layer.borderWidth = 2.0
    self.layer.cornerRadius = 9
    self.layer.masksToBounds = true
    self.touchPointOffset = CGPoint(x: 0, y: YPMagnifyingGlassDefaultOffset)
    self.scale = YPMagnifyingGlassDefaultScale
    self.viewToMagnify = nil
    self.scaleAtTouchPoint = true
    
    let view = UIView(frame: CGRect(
        x: frame.width / 2 - 6,
        y: frame.height / 2 - 6,
        width: 12,
        height: 12
    ))
    view.backgroundColor = UIColor.clear
    view.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
    view.layer.borderWidth = 2.0
    view.layer.cornerRadius = 3
    self.addSubview(view)
  }
  
  private func setFrame(frame: CGRect) {
    self.frame = frame
    self.layer.cornerRadius = frame.size.width / 2
  }
  
  public override func draw(_ rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()!
    context.translateBy(x: self.frame.size.width/2, y: self.frame.size.height/2)
    context.scaleBy(x: self.scale, y: self.scale)
    context.translateBy(x: -self.touchPoint.x, y: -self.touchPoint.y + (self.scaleAtTouchPoint != nil ? 0 : self.bounds.size.height/2))
    self.viewToMagnify.layer.render(in: context)
  }
}
