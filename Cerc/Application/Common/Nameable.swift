//
//  Nameable.swift
//  Cerc
//
//  Created by Kevin Romero Peces-Barba on 7/19/19.
//  Copyright © 2019 Kevin Romero Peces-Barba. All rights reserved.
//

import SwiftUI

protocol Nameable: Identifiable {

    associatedtype NAME: StringProtocol

    var name: Self.NAME { get }

}
