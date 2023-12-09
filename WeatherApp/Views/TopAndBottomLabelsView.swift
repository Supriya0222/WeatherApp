//
//  TopAndBottomLabelsView.swift
//  WeatherApp
//
//  Created by Supriya Rajkoomar on 08/12/2023.
//

import UIKit

class TopAndBottomLabelsView: UIView {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    private func initSubviews() {
        UINib(nibName: "TopAndBottomLabelsView" , bundle: nil).instantiate(withOwner: self)
        contentView.frame = bounds
        addSubview(contentView)
    }

    
}
