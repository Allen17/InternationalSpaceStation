//
//  ISSPassTime.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/16/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ISSPassTime
{
    let risetime:  Double?
    let duration:  Double?
    var date:      NSDate?
    {
        get
        {
            if let timestamp = risetime
            {
                return NSDate(timeIntervalSince1970: timestamp)
            }
            return nil
        }
    }

    init(issPassTimeJSON: JSON)
    {
        risetime = issPassTimeJSON["risetime"].double
        duration = issPassTimeJSON["duration"].double
    }

    static func parsingArray(arrayJSON: [JSON]) -> [ISSPassTime]
    {
        var issPassTimes: [ISSPassTime] = []

        for passTimeJSON in arrayJSON
        {
            let issPassTime =  ISSPassTime(issPassTimeJSON: passTimeJSON)
            issPassTimes.append(issPassTime)
        }
        
        return issPassTimes
    }

}

