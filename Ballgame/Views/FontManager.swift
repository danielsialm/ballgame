//
//  FontManager.swift
//  Ballgame
//
//  Created by Daniel Sialm on 2/10/26.
//

import SwiftUI

struct FontManager {
    struct AvenirNext {
        static let familyRoot   = "AvenirNext"
        
        // weights
        static let heavy        = "\(familyRoot)-Heavy"
        static let bold         = "\(familyRoot)-Bold"
        static let demibold     = "\(familyRoot)-DemiBold"
        static let semibold     = "\(familyRoot)-SemiBold"
        static let regular      = "\(familyRoot)-Regular"
        static let light        = "\(familyRoot)-Light"
    }
}

extension Font {
    public static var title = Font.custom(FontManager.AvenirNext.heavy, size: 36)
    public static var smallTitle = Font.custom(FontManager.AvenirNext.bold, size: 25)
    public static var numberStat = Font.custom(FontManager.AvenirNext.heavy, size: 30)
    public static var headline = Font.custom(FontManager.AvenirNext.bold, size: 22)
    public static var subheadline = Font.custom(FontManager.AvenirNext.demibold, size: 18)
    public static var body = Font.custom(FontManager.AvenirNext.regular, size: 16)
    public static var smallBody = Font.custom(FontManager.AvenirNext.regular, size: 13)
}
