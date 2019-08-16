//
//  LocationHolder.swift
//  Runner
//
//  Created by 活雷轰 on 2019/2/11.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation

class LocationHolder {
    var locationManager: AMapLocationManager? = nil
    
    init() {
        AMapServices.shared()?.apiKey = "33c93e7f9698ee2ce2d81c830b219469"
        locationManager = AMapLocationManager.init()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func startLocation(result: FlutterResult?) {
        locationManager?.requestLocation(withReGeocode: true) { (location, reGeocode, error) in
            if let error = error {
                let error = error as NSError
                
                if (error.code == AMapLocationErrorCode.locateFailed.rawValue) {
                    debugPrint("定位错误:{\(error.code) - \(error.localizedDescription)};")
                } else if (error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue) {
                    debugPrint("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                } else {
                    debugPrint("定位成功！！！")
                }
            }
            
            if let location = location {
                debugPrint("location:\(location)")
            }
            
            if let reGeocode = reGeocode {
                debugPrint("reGeocode:\(reGeocode)")
                if (reGeocode.district != nil) {
                    result?("{\"district\":\"\(reGeocode.district!)\",\"province\":\"\(reGeocode.province!)\"}")
                } else {
                    result?(FlutterMethodNotImplemented)
                }
            } else {
                result?(FlutterMethodNotImplemented)
            }
        }
    }
}
