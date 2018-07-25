/*
* DialView
*
* Created by Jeremy Fox on 3/1/16.
* Copyright (c) 2016 Jeremy Fox. All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/


//  NOTE:
//  This was adapted from the gist here: https://gist.github.com/sketchytech/d0a8909459aea899e67c
//  That gist gave me a great starting point for learning how to determine the CGPoints around a circle and being able to draw lines and labels in or around the circle in equal distances

import UIKit

class DialView: UIView {

    let pointerLayer = PointerLayer()
    fileprivate var rotation: Double = -0.563
    fileprivate let sides = 110
    var labels: [String] {
        return ["А","Б","В","Г","Д","Е","Ё","Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Щ","Э","Ю","Я"]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
      let endAngle = CGFloat(2 * Double.pi)
        let newRect = CGRect(x: rect.minX + 20, y: rect.minY + 20, width: rect.width - 40, height: rect.height - 40)
        let rad = newRect.width / 2
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        ctx.addArc(center: center, radius: rad, startAngle: 0, endAngle: endAngle, clockwise: true)
        ctx.setFillColor(UIColor.white.withAlphaComponent(0.4).cgColor)
        ctx.setStrokeColor(UIColor.white.withAlphaComponent(0.7).cgColor)
        ctx.setLineWidth(0.5)
        ctx.drawPath(using: .fillStroke)
        
        drawMarkers(ctx, x: newRect.midX, y: newRect.midY, radius: rad, sides: sides, color: UIColor.white)
        
        drawText(newRect, ctx: ctx, radius: rad, color: UIColor.white)
        
        if pointerLayer.superlayer != layer {
            pointerLayer.frame = rect
            layer.addSublayer(pointerLayer)
            pointerLayer.setNeedsDisplay()
            let startingRotation = rotationForLabel(labels[0])
            pointerLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: startingRotation))
        }
    }
    
    func rotatePointerToLabel(_ label: String) {
        let rotateTo = rotationForLabel(label)
        let transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: rotateTo))
        if pointerLayer.superlayer == layer && !CATransform3DEqualToTransform(pointerLayer.transform, transform) {
            pointerLayer.transform = transform
        }
    }
    
    fileprivate func degreeToRadian(_ a: CGFloat) -> CGFloat {
        return CGFloat(Double.pi) * a / 180
    }
    
    fileprivate func rotationForLabel(_ label: String) -> CGFloat {
        guard let index = labels.index(of: label) else { return CGFloat(rotation) }
        let rotationStep: CGFloat = 0.045
        return (CGFloat(rotation) + (CGFloat(index) * rotationStep)) / CGFloat(Double.pi / 4)
    }
    
    fileprivate func circleCircumferencePoints(_ sides: Int, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
        let angle = degreeToRadian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i) + degreeToRadian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i) + degreeToRadian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1
        }
        return points
    }
    
    fileprivate func drawMarkers(_ ctx: CGContext, x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, color: UIColor) {
        let points = circleCircumferencePoints(sides, x, y, radius)
        let path = CGMutablePath()
        let divider:CGFloat = 0.03
        for (_,p) in points.enumerated() {
            let xn = p.x + divider * (x - p.x)
            let yn = p.y + divider * (y - p.y)
            // build path
            path.move(to: p)
            path.addLine(to: CGPoint(x: xn, y: yn))
            path.closeSubpath()
            // add path to context
            ctx.addPath(path)
        }
        let cgcolor = color.cgColor
        ctx.setStrokeColor(cgcolor)
        ctx.setLineWidth(1)
        ctx.strokePath()
    }
    
    fileprivate func drawText(_ rect: CGRect, ctx: CGContext, radius: CGFloat, color: UIColor) {
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        ctx.translateBy(x: 0.0, y: rect.height)
        ctx.scaleBy(x: 1.0, y: -1.0)
        // dictates how inset/outset the ring of labels will be
        let inset:CGFloat = 40
        // An adjustment to position labels correctly
        let points = circleCircumferencePoints(sides, rect.midX, rect.midY - inset, radius + (inset / CGFloat(Double.pi)), adjustment: 314)
        for (i,p) in points.enumerated() {
            guard i > 0 else { continue }
            guard i < labels.count + 1 else { return }
            let index = i - 1
            let aFont = UIFont.systemFont(ofSize: 8, weight: .light)
            let attr = [NSAttributedStringKey.font: aFont, .foregroundColor: UIColor.black] as? CFDictionary
          let text = CFAttributedStringCreate(nil, labels[index] as CFString?, attr)
            let line = CTLineCreateWithAttributedString(text!)
            let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.useOpticalBounds)
            ctx.setLineWidth(0.7)
            ctx.setTextDrawingMode(.fill)
            let xn = p.x - bounds.width / 2
            let yn = p.y - bounds.midY
            ctx.textPosition = CGPoint(x: xn, y: yn)
            // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
            // draw the line of text
            CTLineDraw(line, ctx)
            ctx.rotate(by: 0.0)
        }
    }

}
