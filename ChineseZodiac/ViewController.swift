//
//  ViewController.swift
//  ChineseZodiac
//
//  Created by 刘达浮云 on 16/5/12.
//  Copyright © 2016年 刘达浮云. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController ,CLLocationManagerDelegate{
    let  locationManger:CLLocationManager = CLLocationManager()
    
    
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var Weather: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loading: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        
        
        let background = UIImage(named:"background")
        self.view.backgroundColor = UIColor(patternImage: background!)
        
        self.creatLayout()
        
        self.loadingIndicator.startAnimating()
        
        
        locationManger.requestAlwaysAuthorization()
        locationManger.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func creatLayout() {
        print(location.frame)
        
        location.frame = CGRectMake(20, 40, UIScreen.mainScreen().bounds.width-40, 40)
        
        location.font = UIFont(name: "", size: 35)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location:CLLocation = locations[locations.count-1] as CLLocation
        
        if (location.horizontalAccuracy > 0) {
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            
            self.updateWeatherInfo(location.coordinate.latitude,longitude:location.coordinate.longitude)
            
            locationManger.stopUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print(error)
        self.loading.text = "地理位置信息不可用"
    }
    
    
    func updateWeatherInfo(latitude:CLLocationDegrees,longitude:CLLocationDegrees){
      
        
        let manager = AFHTTPSessionManager()
        let url = "http://lbs.juhe.cn/api/getaddressbylngb"
        let params = ["lngy":latitude,"lngx":longitude,"dtype":"json"]

        manager.GET(url, parameters: params, progress: nil, success: { (_, JSON) -> Void in
            print(JSON)
            
            self.updateSuccess(JSON as! NSDictionary!)
            
            }) { (_, error) -> Void in
                print(error)
                
        }
        

    }
    
    func updateSuccess(jsonResult:NSDictionary) -> Void {
        self.loadingIndicator.hidden = true
        self.loadingIndicator.stopAnimating()
        self.loading.text = nil
        
        if let city = jsonResult["row"]?["result"]?!["addressComponent"]?!["city"]?! as? String {
            print(city)
            
            let manager = AFHTTPSessionManager()
            let url = "http://v.juhe.cn/weather/index"
            let params = ["format":2,"cityname":city,"key":"ead46e88f98d038cd48730bdcde2"] //key是自己注册获得的，有免费500次使用次数：https://www.juhe.cn
            
            manager.GET(url, parameters: params, progress: nil, success: { (_, JSON) in
                print(JSON)
                var temperature: String
                var weatherIcon: String
                var weatherText: String
                
                let dis = JSON as! NSDictionary
                
                
                temperature = (dis["result"]?["today"]?!["temperature"]?! as? String)!
                weatherText = (dis["result"]?["today"]?!["weather"]?! as? String)!
                weatherIcon = (dis["result"]?["today"]?!["weather_id"]?!["fa"]?! as? String)!
                
                self.temperature.text = temperature
                self.Weather.text = weatherText
                self.location.text = city
                
                let i = weatherIcon
                switch i {
                case "00":
                    self.icon.image = UIImage(named: "qing")
                case "01":
                    self.icon.image = UIImage(named: "yun")
                case "02":
                    self.icon.image = UIImage(named: "yun")
                case "03":
                    self.icon.image = UIImage(named: "yu")
                case "04":
                    self.icon.image = UIImage(named: "dian")
                case "05":
                    self.icon.image = UIImage(named: "dian")
                case "06":
                    self.icon.image = UIImage(named: "xue")
                case "07":
                    self.icon.image = UIImage(named: "yu")
                case "08":
                    self.icon.image = UIImage(named: "yu")
                case "09":
                    self.icon.image = UIImage(named: "dayu")
                case "10":
                    self.icon.image = UIImage(named: "dayu")
                case "11":
                    self.icon.image = UIImage(named: "dayu")
                case "12":
                    self.icon.image = UIImage(named: "dayu")
                case "13":
                    self.icon.image = UIImage(named: "xue")
                case "14":
                    self.icon.image = UIImage(named: "xue")
                case "15":
                    self.icon.image = UIImage(named: "xue")
                case "16":
                    self.icon.image = UIImage(named: "xue")
                case "17":
                    self.icon.image = UIImage(named: "xue")
                case "18":
                    self.icon.image = UIImage(named: "wu")
                case "19":
                    self.icon.image = UIImage(named: "dayu")
                case "20":
                    self.icon.image = UIImage(named: "dafeng")
                case "21":
                    self.icon.image = UIImage(named: "yu")
                case "22":
                    self.icon.image = UIImage(named: "dayu")
                case "23":
                    self.icon.image = UIImage(named: "dayu")
                case "24":
                    self.icon.image = UIImage(named: "dayu")
                case "25":
                    self.icon.image = UIImage(named: "dayu")
                case "26":
                    self.icon.image = UIImage(named: "xue")
                case "27":
                    self.icon.image = UIImage(named: "xue")
                case "28":
                    self.icon.image = UIImage(named: "xue")
                case "29":
                    self.icon.image = UIImage(named: "feng")
                case "30":
                    self.icon.image = UIImage(named: "feng")
                case "31":
                    self.icon.image = UIImage(named: "feng")
                case "53":
                    self.icon.image = UIImage(named: "wu")
              
                default:
                    print("Error==")
                }
                
                
                
                }, failure: { (_, error) in
                    print(error)
                    
            })
        }
        else{
            self.loading.text = "天气信息不可用"
            print("NO")
        }
    }
    
    
    
}

