//
//  RoundedLayer.swift
//  hackday-appstore
//
//  Created by yangpc on 2018. 5. 17..
//  Copyright © 2018년 yang hee jung. All rights reserved.
//

import UIKit

class RoundedLayer: CALayer {

    override var bounds: CGRect {
        didSet { cornerRadius = bounds.height / 2.0 }
    }

}
