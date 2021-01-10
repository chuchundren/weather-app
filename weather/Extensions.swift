//
//  Extensions.swift
//  weather
//
//  Created by Дарья on 13.11.2020.
//  Copyright © 2020 chuchundren. All rights reserved.
//

import Foundation

extension String {
    func crop() -> String {
        let halfCropped = self.trimmingCharacters(in: .init(charactersIn: "[weather.Weather(description: \""))
        let fullyCropped = halfCropped.trimmingCharacters(in: .init(charactersIn: "\")]"))
        return fullyCropped
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension Float {
    func convertKelvinToCelsium() -> Int {
        return Int(self - 273.15)
    }
}

extension String {
    func replaceSpaceAndTrim() -> String {
        var string = self
            if string.contains(" ") {
                let spaceIndex = string.firstIndex(of: " ")
                string.remove(at: spaceIndex!)
                string.insert(contentsOf: "%20", at: spaceIndex!)
        }
        string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        return string
    }
}
