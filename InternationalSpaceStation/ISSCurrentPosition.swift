//
//  ISSCurrentPosition.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/16/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

struct ISSCurrentPosition
{
    let latitude:      Double?
    let longitude:     Double?
    let timestamp:     Double?
    var coordinate:    CLLocationCoordinate2D?
    {
        get
        {
            if let lat = self.latitude, lng = self.longitude
            {
                return CLLocationCoordinate2D(latitude: lat, longitude: lng)
            }
            return nil
        }
    }

    init(issPositionJSON: JSON)
    {
        let positionDictionary = issPositionJSON["iss_position"].dictionary

        latitude = positionDictionary?["latitude"]?.double
        longitude = positionDictionary?["longitude"]?.double

        timestamp = issPositionJSON["timestamp"].double
    }
}
