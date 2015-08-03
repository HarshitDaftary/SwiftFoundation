//
//  HTTPVersion.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 6/29/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

/// Defines the HTTP protocol version.
public struct HTTPVersion {
    
    public typealias ValueType = UInt8
    
    /** Major version number. */
    public var major: ValueType
    
    /** Minor version number. */
    public var minor: ValueType
    
    /// Defualts to HTTP 1.1
    public init(_ major: ValueType = 1, _ minor: ValueType = 1) {
        
        self.major = major
        self.minor = minor
    }
}