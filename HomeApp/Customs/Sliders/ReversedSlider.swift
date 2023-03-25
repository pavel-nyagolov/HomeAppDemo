//
//  ReversedSlider.swift
//  HomeApp
//
//  Created by Pavel on 24.03.23.
//

import UIKit

@IBDesignable
class ReversedSlider: UIControl {
    
    var delegate: ReversedSliderDelegate?
    
    @IBInspectable
    var currentValue: CGFloat = 0.5 {
        didSet {
            updatePaths()
        }
    }
    
    @IBInspectable
    var minValue: CGFloat = 0 {
        didSet {
            updatePaths()
        }
    }
    
    @IBInspectable
    var maxValue: CGFloat = 1 {
        didSet {
            updatePaths()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 20 {
        didSet {
            updatePaths()
        }
    }
    
    @IBInspectable
    var handleWidth: CGFloat = 10 {
        didSet {
            updatePaths()
        }
    }
    
    @IBInspectable
    var color: UIColor = .brown {
        didSet {
            updatePaths()
        }
    }
    
    private var arcCenter: CGPoint = .zero
    private var startAngle: CGFloat = .zero
    private var endAngle: CGFloat = .zero
    
    private lazy var handleLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        let rect = CGRect(x: 0,
                          y: 0,
                          width: borderWidth + handleWidth,
                          height: borderWidth + handleWidth)
        layer.frame = rect
        layer.cornerRadius = rect.width / 2
        
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSizeMake(0, 0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 5
        
        return layer
    }()
    
    private lazy var progressShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
        return shapeLayer
    }()
    
    private lazy var totalShapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.systemGray6.cgColor
        return shapeLayer
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    func configure() {
        progressShapeLayer.strokeColor = color.cgColor
        
        layer.addSublayer(totalShapeLayer)
        layer.addSublayer(progressShapeLayer)
        layer.addSublayer(handleLayer)
    }
    
    func updatePaths() {
        let rect = bounds.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        let halfWidth = rect.width / 2
        let height = rect.height
        let theta = atan(halfWidth / height)
        let radius = sqrt(halfWidth * halfWidth + height * height) / 2 / cos(theta)
        
        let range = maxValue - minValue
        let correctValue = currentValue - minValue
        let percentage = ((correctValue * 100) / range) / 100
        
        arcCenter = CGPoint(x: rect.midX, y: rect.minY - 30)
        let delta = (.pi / 2 - theta) * 2
        startAngle = (.pi * 3 / 2 + delta) + .pi
        endAngle = (.pi * 3 / 2 - delta) + .pi
        
        let path = UIBezierPath(arcCenter: arcCenter,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: false)

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        progressShapeLayer.path = path.cgPath
        totalShapeLayer.path = path.cgPath
        progressShapeLayer.strokeEnd = percentage

        let currentAngle = (endAngle - startAngle) * percentage + startAngle
        let dotCenter = CGPoint(x: arcCenter.x + radius * cos(currentAngle),
                                y: arcCenter.y + radius * sin(currentAngle))
        handleLayer.position = dotCenter

        CATransaction.commit()
    }
}

extension ReversedSlider {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updatedProgress(for: touches.first, touch: .began)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        updatedProgress(for: touches.first, touch: .moved)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updatedProgress(for: touches.first, touch: .ended)
    }
    
    func updatedProgress(for touch: UITouch?, touch type: TouchType) {
        guard let touch = touch else { return }
        let point = touch.location(in: self)
        
        let angle = atan2(point.y - arcCenter.y, point.x - arcCenter.x) + 2 * .pi
        
        let percent = (angle - startAngle) / (endAngle - startAngle)
        
        currentValue = max(minValue, min(maxValue, percent))
        
        switch type {
        case .began:
            delegate?.reversedSliderBegan(value: Double(currentValue))
        case .moved:
            delegate?.reversedSliderMoved(value: Double(currentValue))
        case .ended:
            delegate?.reversedSliderEnded(value: Double(currentValue))
        }
    }
}
