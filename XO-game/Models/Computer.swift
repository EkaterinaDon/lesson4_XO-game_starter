//
//  Computer.swift
//  XO-game
//
//  Created by Ekaterina on 25.12.20.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public enum Computer: CaseIterable {
    case first
    case second
    
    var next: Computer {
        switch self {
        case .first: return .second
        case .second: return .first
        }
    }
    
    var markViewPrototype: MarkView {
        switch self {
        case .first: return XView()
        case .second: return OView()
        }
    }
}
