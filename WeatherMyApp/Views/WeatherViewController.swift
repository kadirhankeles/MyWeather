//
//  ViewController.swift
//  WeatherMyApp
//
//  Created by Kadirhan Keles on 14.08.2023.
//

import UIKit
//MARK: - WeatherViewInterface
protocol WeatherViewInterface: AnyObject {
    func prepareCollectionView()
    func prepareTextField()
    func updateUI()
    func didFetchDatas()
    
}
//MARK: - WeatherViewController
final class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var detailCollectionView: UICollectionView!
    @IBOutlet private weak var tempCollectionView: UICollectionView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var tempImageView: UIImageView!
    @IBOutlet private weak var tempLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var textfield: UITextField!
    
    

    private var viewModel: WeatherViewModelInterface!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel()
        viewModel.delegate = self
        viewModel.fetchAllDatas(city: "istanbul")
        prepareCollectionView()
        prepareTextField()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if let city = textfield.text {
            viewModel.fetchAllDatas(city: city)
        }
    }
    
}
//MARK: - UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
extension WeatherViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView == tempCollectionView {
                return viewModel.weatherList.count
            } else if collectionView == detailCollectionView {
                return min(viewModel.weatherList.count, 4)
            }
            
            return Int()
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tempCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TempCollectionViewCell", for: indexPath) as! TempCollectionViewCell
            let data = viewModel.weatherList[indexPath.row]
            
            cell.list = data
            
            return cell
        } else if collectionView == detailCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
            let data = viewModel.weatherList[0]
            if indexPath.row == 0 {
                cell.detailImageView.image = UIImage(systemName: viewModel.detailImageView(index: indexPath.row))
                cell.detailBoldLabel.text = viewModel.convertDouble(temp: (data.main?.tempMax)!)
                cell.detailLabel.text = "Max Temp."
            } else if indexPath.row == 1 {
                cell.detailImageView.image = UIImage(systemName: viewModel.detailImageView(index: indexPath.row))
                cell.detailBoldLabel.text = viewModel.convertDouble(temp: (data.main?.tempMin)!)
                cell.detailLabel.text = "Min Temp."
            } else if indexPath.row == 2 {
                cell.detailImageView.image = UIImage(systemName: viewModel.detailImageView(index: indexPath.row))
                cell.detailBoldLabel.text = "\(data.main?.humidity ?? 0)%"
                cell.detailLabel.text = "Humidity"
            } else if indexPath.row == 3 {
                cell.detailImageView.image = UIImage(systemName: viewModel.detailImageView(index: indexPath.row))
                cell.detailBoldLabel.text = "\(data.wind?.speed ?? 0) m/s"
                cell.detailLabel.text = "Wind Speed"
            }
            return cell
        }
        return UICollectionViewCell()
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == detailCollectionView {
            let width: CGFloat = collectionView.frame.width / 2.2
            let height: CGFloat = width / 2
            
            return CGSize(width: width, height: height)
        } else if collectionView == tempCollectionView {
            let width: CGFloat = 90
            let height: CGFloat = 120
            
            return CGSize(width: width, height: height)
        }
        return CGSize()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        if let city = textField.text {
            viewModel.fetchAllDatas(city: city)
            print(city)
        }
        return true
    }
}

//MARK: - WeatherViewInterface
extension WeatherViewController: WeatherViewInterface {
    func prepareTextField() {
        textfield.delegate = self
    }

    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.tempCollectionView.reloadData()
            self?.detailCollectionView.reloadData()
            
            if let temp = self?.viewModel.weatherList.first?.main?.temp {
                self?.tempLabel.text = self?.viewModel.convertDouble(temp: temp)
            }
            if let cityName = self?.viewModel.city?.name,
               let countryName = self?.viewModel.city?.country{
                self?.cityLabel.text = "\(cityName), \(countryName)"
            }
            self?.dateLabel.text = self?.viewModel.updateTime()
            if let weatherId = self?.viewModel.weatherList[0].weather?[0].id {
                self?.tempImageView.image = UIImage(systemName: (self?.viewModel.getConditionName(weatherId: weatherId))!)
            }
            self?.textfield.text = ""
        }
    }
    
    func prepareCollectionView() {
        
        let nib = UINib(nibName: "TempCollectionViewCell", bundle: Bundle(for: TempCollectionViewCell.self))
        tempCollectionView.register(nib, forCellWithReuseIdentifier: "TempCollectionViewCell")
        
        let detailNib = UINib(nibName: "DetailCollectionViewCell", bundle: Bundle(for: DetailCollectionViewCell.self))
        detailCollectionView.register(detailNib, forCellWithReuseIdentifier: "DetailCollectionViewCell")

        tempCollectionView.delegate = self
        tempCollectionView.dataSource = self
        
        detailCollectionView.delegate = self
        detailCollectionView.dataSource = self
    }
    
    func didFetchDatas() {
        updateUI()
    }
    
    
}
