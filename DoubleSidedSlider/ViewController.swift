//
//  ViewController.swift
//  DoubleSidedSlider
//
//  Created by Alex Nasulloev on 19/03/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        view.text = "00:00"
        view.textColor = UIColor(red: 0.529, green: 0.557, blue: 0.596, alpha: 1)
        return view
    }()
    
    private let intervalSlider: RangeSlider = {
        let view = RangeSlider()
        view.minimumValue = 0
        view.maximumValue = 1439
        view.lowerValue = 0
        view.upperValue = 1439
        view.inIntervalTrackColor = UIColor(red: 0.102, green: 0.318, blue: 0.765, alpha: 1)
        view.outIntervalTrackColor = UIColor(red: 0.957, green: 0.965, blue: 0.969, alpha: 1)
        view.upperThumbImage = UIImage(named: "Ring")
        view.lowerThumbImage = UIImage(named: "Ring")
        view.activeUpperThumbImage = UIImage(named: "Dot")
        view.activeLowerThumbImage = UIImage(named: "Dot")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpSlidersActions()
        setTime()
    }
    
    private func setTime() {
        let from = setText(value: intervalSlider.lowerValue)
        let to = setText(value: intervalSlider.upperValue)
        titleLabel.text = "\(from) - \(to)"
    }
    
    private func setText(value: Float) -> String {
        let departureCountmin = Int(Double(value))
        let hours = String(format: "%02d", departureCountmin / 60)
        let minutes = String(format: "%02d", departureCountmin - (Int(hours)! * 60))
        return "\(hours):\(minutes)"
    }
    
    private func setupView() {
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(intervalSlider)
        
        NSLayoutConstraint.activate([
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            
            intervalSlider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            intervalSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            intervalSlider.heightAnchor.constraint(equalToConstant: 24),
            intervalSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
        ])
    }
    
    private func setUpSlidersActions() {
        intervalSlider.addTarget(self, action: #selector(toggleValueChanged), for: .valueChanged)
    }
    
    @objc func toggleValueChanged() {
        setTime()
    }
}

#Preview {
    ViewController()
}
