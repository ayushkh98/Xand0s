//
//  AlertItem.swift
//  X@0's
//
//  Created by Ayush Khanna on 17/06/2021.
//

import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
    
}

struct AlertContext {
   static let humanWin = AlertItem(title: Text("You won!!!"), message: Text("You beat you own AI!"), buttonTitle: Text("Yes!!!"))
   static let computerWin = AlertItem(title: Text("You Lost :("), message: Text("You cant beat AI can u"), buttonTitle: Text("Rematch"))
   static let draw = AlertItem(title: Text("Draw"), message: Text("Amazong clash of wits"), buttonTitle: Text("Play again"))
}
