//
//  TempCollectionViewCell.swift
//  WeatherMyApp
//
//  Created by Kadirhan Keles on 14.08.2023.
//

import UIKit

final class TempCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var tempImageView: UIImageView!
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var tempLabel: UILabel!
    
    private var viewModel: WeatherViewModelInterface! = WeatherViewModel()
    
    var list: List? {
        didSet {
            if let weatherId = list?.weather?[0].id {
                tempImageView.image = UIImage(systemName: (viewModel.getConditionName(weatherId: weatherId)))
            }
            if let date = list?.dtTxt {
                hourLabel.text = viewModel.convertToHourFormat(from: date)
            }
            if let temp = list?.main?.temp {
                tempLabel.text = viewModel.convertDouble(temp: temp)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        list = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        list = nil
    }

}
