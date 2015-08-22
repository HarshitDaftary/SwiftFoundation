//
//  JSONSerialization.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/22/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

import JSON

public extension JSON {
    
    public struct Serialization {
        
        /// Options for serializing JSON.
        public enum WritingOption: BitMaskOption {
            
            /// Causes the output to have minimal whitespace inserted to make things slightly more readable.
            case Spaced
            
            /// Causes the output to be formatted. See the "Two Space Tab" option at http://jsonformatter.curiousconcept.com/
            /// for an example of the format.
            case Pretty
            
            /// Causes the output to be formatted. Instead of a "Two Space Tab" this gives a single tab character.
            case PrettyTab
            
            /// Drop trailing zero for float values
            case NoZero
            
            public init?(rawValue: Int32) {
                
                switch rawValue {
                    
                case JSON_C_TO_STRING_SPACED:       self = .Spaced
                case JSON_C_TO_STRING_PRETTY:       self = .Pretty
                case JSON_C_TO_STRING_PRETTY_TAB:   self = .PrettyTab
                case JSON_C_TO_STRING_NOZERO:       self = .NoZero
                    
                default: return nil
                }
            }
            
            public var rawValue: Int32 {
                
                switch self {
                    
                case Spaced:        return JSON_C_TO_STRING_SPACED
                case Pretty:        return JSON_C_TO_STRING_PRETTY
                case PrettyTab:     return JSON_C_TO_STRING_PRETTY_TAB
                case NoZero:        return JSON_C_TO_STRING_NOZERO
                }
            }
        }
    }
}

public extension JSON.Value {
    
    /// Serializes the JSON to a string.
    func toString(options: [JSON.Serialization.WritingOption]) -> Swift.String {
        
        let jsonObject = self.toJSONObject()
        
        defer { json_object_put(jsonObject) }
        
        let writingFlags = options.optionsBitmask()
        
        let stringPointer = json_object_to_json_string_ext(jsonObject, writingFlags)
        
        let string = Swift.String.fromCString(stringPointer)!
        
        return string
    }
}

public extension JSON.Value {
    
    func toJSONObject() -> COpaquePointer {
        
        switch self {
            
        case .Null: return json_object_new_array() // FIXME: 
            
        case .String(let value): return json_object_new_string(value)
            
        case .Number(let number):
            
            switch number {
                
            case .Boolean(let value):
                
                let jsonBool: Int32 = { if value { return Int32(1) } else { return Int32(0) } }()
                
                return json_object_new_boolean(jsonBool)
                
            case .Integer(let value): return json_object_new_int64(Int64(value))
                
            case .Double(let value): return json_object_new_double(value)
            }
            
        case .Array(let arrayValue):
            
            let jsonArray = json_object_new_array()
            
            for (index, value) in arrayValue.enumerate() {
                
                let jsonValue = value.toJSONObject()
                
                json_object_array_put_idx(jsonArray, Int32(index), jsonValue)
            }
            
            return jsonArray
            
        case .Object(let dictionaryValue):
            
            let jsonObject = json_object_new_object()
            
            for (key, value) in dictionaryValue {
                
                let jsonValue = value.toJSONObject()
                
                json_object_object_add(jsonObject, key, jsonValue)
            }
            
            return jsonObject
        }
    }
}
