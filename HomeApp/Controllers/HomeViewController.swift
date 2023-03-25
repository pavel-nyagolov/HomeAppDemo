//
//  ViewController.swift
//  HomeApp
//
//  Created by Pavel on 24.03.23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var topSlider: SolidSlider!
    @IBOutlet weak var topSliderLabel: UILabel!
    @IBOutlet weak var bottomSlider: ReversedSlider!
    @IBOutlet weak var bottomSliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topSlider.delegate = self
        bottomSlider.delegate = self
        
        topSliderLabel.text = "\(topSlider.currentValue)"
        bottomSliderLabel.text = "\(bottomSlider.currentValue)"
        
        circleView.layer.cornerRadius = circleView.frame.height / 2
    }
}

extension HomeViewController: SolidSliderDelegate {
    func solidSliderBegan(value: Double) {
        topSliderLabel.text = "Begin \(value)"
    }
    
    func solidSliderMoved(value: Double) {
        topSliderLabel.text = "Moving \(value)"
    }
    
    func solidSliderEnded(value: Double) {
        topSliderLabel.text = "End \(value)"
        
        if topSlider.currentValue == 1 && bottomSlider.currentValue == 1 {
            performSegue(withIdentifier: "showNext", sender: self)
        }
    }
}

extension HomeViewController: ReversedSliderDelegate {
    func reversedSliderBegan(value: Double) {
        bottomSliderLabel.text = "Begin \(value)"
    }
    
    func reversedSliderMoved(value: Double) {
        bottomSliderLabel.text = "Moving \(value)"
    }
    
    func reversedSliderEnded(value: Double) {
        bottomSliderLabel.text = "End \(value)"
        
        if topSlider.currentValue == 1 && bottomSlider.currentValue == 1 {
            performSegue(withIdentifier: "showNext", sender: self)
        }
    }
}
