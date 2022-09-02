//
//  ViewController.swift
//  test13
//
//  Created by Nihad Ismayilov on 10.02.22.
//

import UIKit
import CoreLocation
import SDWebImage

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
                        let group = DispatchGroup()
                        let decoder = try JSONDecoder().decode(WeatherResponse.self, from: data!)
                        
                            DispatchQueue.main.async {
                                self.countryNameLabel.text = "\(decoder.location?.name ?? "-"), \(decoder.location?.country ?? "-")"
                                self.dateLabel.text = decoder.location?.localtime ?? "-"
                                self.weatherConditionLabel.text = decoder.current?.weather_descriptions?[0] ?? "-"
                                self.temperatureLabel.text = "\(decoder.current?.temperature ?? 0)"
                                self.windLabel.text = "\(decoder.wind_speed ?? 0)km/h"
                                self.humidityLabel.text = "\(decoder.current?.humidity ?? 0)%"
                                self.visibilityLabel.text = "\(decoder.current?.visibility ?? 0)km"
                                print(decoder.current?.weather_icons)
                                self.imageView.sd_setImage(with: URL.init(string:  decoder.current?.weather_icons?[0] ?? "-"))
                            }
                        
//                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
//
//                        print(jsonResponse)
//
//                        DispatchQueue.main.async {
//                            print (jsonResponse)
//
//                            if let location = jsonResponse["location"] as? [String: Any] {
//                                //print(location)
//
//                                if let name = location["name"] as? String {
//                                    if let country = location["country"] as? String {
//                                        self.countryNameLabel.text = "\(name), \(country)"
//                                    }
//                                }
//                                if let time = location["localtime"] as? String {
//                                    self.dateLabel.text = time
//                                }
//                            }
//                            if let current = jsonResponse["current"] as? [String: Any] {
//                                //(current)
//                                if let weather_descriptions = current["weather_descriptions"] as? Array<String> {
//                                    self.weatherConditionLabel.text = String(weather_descriptions[0])
//                                }
//                                if let temperature = current["temperature"] as? Int {
//                                    self.temperatureLabel.text = "\(temperature)°"
//                                }
//                                if let wind_speed = current["wind_speed"] as? Int {
//                                    self.windLabel.text = "\(wind_speed)km/h"
//                                }
//                                if let humidity = current["humidity"] as? Int {
//                                    self.humidityLabel.text = "\(humidity)%"
//                                }
//                                if let visibility = current["visibility"] as? Int {
//                                    self.visibilityLabel.text = "\(visibility)km"
//                                }
//                            }
//                        }
                    } catch {
                        print ("error")
                    }
                }
            }
        }
        task.resume()
    }


}

struct WeatherResponse: Decodable {
    let location: Location?
    let current: Current?
    let wind_speed: Int?
}

struct Location: Decodable {
    let country: String?
    let name: String?
    let localtime: String?
}

struct Current: Decodable {
    let humidity: Int?
    let temperature: Int?
    let visibility: Int?
    let weather_descriptions: [String]?
    let weather_icons: [String]?
}
