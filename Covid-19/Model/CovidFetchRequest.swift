//
//  CovidFetchRequest.swift
//  Covid-19
//
//  Created by mohamed elgharpawi on 5/13/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class CovidFetchRequest: ObservableObject {
    @Published var totalData:TotalData=testTotalData
    @Published var allCountries :[CountryData]=[]
    
    let headers:HTTPHeaders = [
               "x-rapidapi-host": "covid-19-data.p.rapidapi.com",
               "x-rapidapi-key": "d172e810e7msh47584ae043c146dp12d8eejsnb0b3c42c4a59"
           ]
           
    init() {
        getTotal()
        getAllCountries()
    }
    
    func getTotal()  {
        
       
        AF.request("https://covid-19-data.p.rapidapi.com/totals?format=json",headers: headers).responseJSON{response in
            

            let result = response.data
            
            if result != nil {
                
                let  json = JSON(result!)
                
               // print(json)
                let confirmed = json[0]["confirmed"].intValue
                let deaths = json[0]["deaths"].intValue
                let recovered = json[0]["recovered"].intValue
                let critical = json[0]["critical"].intValue
                self.totalData = TotalData(confirmed: confirmed, critical: critical, deaths: deaths, recovered: recovered)
            }
            else{
                
                self.totalData=testTotalData
                
            }
            
            
            
        }

    }
    func getAllCountries()  {
        var Countries:[CountryData]=[]
        
        AF.request("https://covid-19-data.p.rapidapi.com/country/all?format=undefined",headers: headers).responseJSON{response in
            
            let result = response.value
            if result != nil {
                
                let dataDict = result as! [Dictionary<String,AnyObject>]
                
                for countryData in dataDict {
                    
                    let country = countryData["country"] as? String ?? "Not Found"
                    
                    let longitude = countryData["longitude"] as? Double ?? 0.0
                    
                    let latitude = countryData["latitude"] as? Double ?? 0.0
                   let confirmed = countryData["confirmed"] as? Int64 ?? 0
                    let deaths = countryData["deaths"] as? Int64 ?? 0
                    let recovered = countryData["recovered"] as? Int64 ?? 0
                    let critical = countryData["critical"] as? Int64 ?? 0
                    let countryObj=CountryData(country: country, confirmed: confirmed, critical: critical, deaths: deaths, recovered: recovered, longitude: longitude, latitude: latitude)
                    
                    Countries.append(countryObj)
                    
                    
                }
                
                
                
            }
            self.allCountries=Countries.sorted(by: {$0.confirmed > $1.confirmed})
            
    }
    
    
}
}
