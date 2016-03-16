//
//  ISSNetwork.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/16/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ISSNetwork
{
    private let currentPositionURLString = "http://api.open-notify.org/iss-now.json"
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

                if let haveData = data
                {
                    let json = JSON(data: haveData)
                    let currentPosititon = ISSCurrentPosition(issPositionJSON: json)

                    issPosition(position: currentPosititon)
                }

                issPosition(position: nil)
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
