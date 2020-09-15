//
//  File.swift
//  
//
//  Created by Hannes Hertach on 15.09.20.
//

import Foundation

public enum Region {
    case EU, US
}

extension Region {
    func getURL() -> URL {
        switch (self) {
        case .EU:
            return URL(string: "https://http-intake.logs.datadoghq.eu/v1/input")!
        case .US:
            return URL(string: "https://http-intake.logs.datadoghq.com/v1/input")!
        }
    }
}
