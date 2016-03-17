//
//  ISSNetwork.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/16/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class ISSNetwork
{
    private let currentPositionURLString = "http://api.open-notify.org/iss-now.json"
    private let passTimeURLString        = "http://api.open-notify.org/iss-pass.json"
    private let header = ["Content-Type" : "application/json",
                                "Accept" : "application/json"]

    func getCurrentISSLocation(issPosition: (position: ISSCurrentPosition?) -> ())
    {
        Alamofire.request(Method.GET, currentPositionURLString, parameters: nil,
            encoding: ParameterEncoding.URL, headers: header)
            .response {[weak self] (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in

                guard let strongSelf = self else
                {
                    issPosition(position: nil)
                    return
                }

                if let returnError = error
                {
                    print("error -> \(returnError.localizedDescription)")
                    strongSelf.displayErrorMessage(returnError.localizedDescription)

                    issPosition(position: nil)
                    return
                }

                if let haveData = data where JSON(data: haveData)["message"].string == "success"
                {
                    let json = JSON(data: haveData)
                    let currentPosititon = ISSCurrentPosition(issPositionJSON: json)

                    issPosition(position: currentPosititon)
                    return
                }
                else if let haveData = data,
                       reasonFailure = JSON(data: haveData)["reason"].string

                {
                    print("reasonFailure -> " + reasonFailure)
                    strongSelf.displayErrorMessage(reasonFailure)
                }

                issPosition(position: nil)
        }
    }

    func getPassTime(coordinate: CLLocationCoordinate2D, passTimes: (([ISSPassTime]?)-> ()))
    {

        let parameters = ["lat" : coordinate.latitude,
                          "lon" : coordinate.longitude]

        Alamofire.request(Method.GET, passTimeURLString, parameters: parameters,
            encoding: ParameterEncoding.URL, headers: header)
            .response {[weak self] (request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> Void in

                guard let strongSelf = self else
                {
                    passTimes(nil)
                    return
                }

                if let returnError = error
                {
                    print("error -> \(returnError.localizedDescription)")
                    strongSelf.displayErrorMessage(returnError.localizedDescription)

                    passTimes(nil)
                    return
                }

                if let haveData = data where JSON(data: haveData)["message"].string == "success",
                   let issPassTimeJSONArray = JSON(data: haveData)["response"].array
                {
                    let passTimesArray = ISSPassTime.parsingArray(issPassTimeJSONArray)

                    passTimes(passTimesArray)
                    return
                }
                else if let haveData = data,
                    reasonFailure = JSON(data: haveData)["reason"].string

                {
                    print("reasonFailure -> " + reasonFailure)
                    strongSelf.displayErrorMessage(reasonFailure)
                }
                
                passTimes(nil)
        }
    }

    func displayErrorMessage(errorMessage: String)
    {
        let alertViewController = UIAlertController(title: "Sorry", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelButton = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil)

        alertViewController.addAction(cancelButton)

        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController

        rootViewController?.presentViewController(alertViewController, animated: true, completion: nil)
        
    }

}
