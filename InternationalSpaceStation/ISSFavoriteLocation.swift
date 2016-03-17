//
//  ISSFavoriteLocation.swift
//  InternationalSpaceStation
//
//  Created by Allen Wong on 3/17/16.
//  Copyright © 2016 Allen Wong. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation


class ISSFavoriteLocation
{
    let sharedInstance = ISSFavoriteLocation()

    var favoriteLocation: [MKAnnotation] = []
}