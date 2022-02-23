//
//  ViewController.swift
//  test13
//
//  Created by Nihad Ismayilov on 10.02.22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chosenCity = "Baku"
        let url = URL(string: "http://api.weatherstack.com/current?access_key=0f219a1baedbd42bca056df0429ec15b&query=\(chosenCity)")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            } else {
                if data != nil {
                    
                    do {
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                        
                        DispatchQueue.main.async {
                            //print (jsonResponse)
                            
                            if let location = jsonResponse["location"] as? [String: Any] {
                                //print(location)
                                
                                if let name = location["name"] as? String {
                                    if let country = location["country"] as? String {
                                        self.countryNameLabel.text = "\(name), \(country)"
                                    }
                                }
                                if let time = location["localtime"] as? String {
                                    self.dateLabel.text = time
                                }
                            }
                            if let current = jsonResponse["current"] as? [String: Any] {
                                //(current)
                                if let weather_descriptions = current["weather_descriptions"] as? Array<String> {
                                    self.weatherConditionLabel.text = String(weather_descriptions[0])
                                }
                                if let temperature = current["temperature"] as? Int {
                                    self.temperatureLabel.text = "\(temperature)°"
                                }
                                if let wind_speed = current["wind_speed"] as? Int {
                                    self.windLabel.text = "\(wind_speed)km/h"
                                }
                                if let humidity = current["humidity"] as? Int {
                                    self.humidityLabel.text = "\(humidity)%"
                                }
                                if let visibility = current["visibility"] as? Int {
                                    self.visibilityLabel.text = "\(visibility)km"
                                }
                            }
                        }
                    } catch {
                        print ("error")
                    }
                }
            }
        }
        task.resume()
    }


}

