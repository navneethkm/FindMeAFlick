//
//  Secrets.swift
//  FindMeAFlick
//
//  Created by P10 on 15/09/25.
//

import Foundation

enum Secrets {
    private static var dict: [String:Any]? {
        guard let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let obj = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String:Any] else {
            return nil
        }
        return obj
    }
    static var tmdbKey: String {
        return "8769fac6f9c85640757a20372981e64e"
    }
}
