//
//  K.swift
//  AdapSchApp
//
//  Created by Sonny Cooper on 03/09/2023.
//

import Foundation
import SwiftUI

struct K {
    //all the custom colours
    struct Colors{
        static let background1 = Color("BackgroundMainColor")
        static let background2 = Color("BackgoundSecondaryColor")
        static let tab = Color("TabColor")
        static let text = Color("TextColor")
    }
    //only have 11 colours for categories atm
    static let categoryBoxColors: [(String, String)] = [("#FFA640", "#762F00"), ("#ADC400", "#414906"), ("#5ED100", "#264E06"),
                                                        ("#09D58A", "#004F32"), ("#0BCED1", "#024C4E"), ("#58C2FF", "#21485F"),
                                                        ("#BAAEFF", "#453C76"), ("#D5A5FF", "#5F2790"), ("#FD90FF", "#7B027D"),
                                                        ("#D8ACC4", "#801550"), ("#FF9CB0", "#8A0B25")]
    
}
