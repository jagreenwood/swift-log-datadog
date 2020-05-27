//
//  File.swift
//  
//
//  Created by Jeremy Greenwood on 5/26/20.
//

import Logging

extension Logger.Metadata {
    var prettified: String? {
        !isEmpty ? map { "\($0):\($1)" }.sorted(by: <).joined(separator: ",") : nil
    }
}
