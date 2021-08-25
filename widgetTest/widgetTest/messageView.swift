//
//  messageView.swift
//  widgetTest
//
//  Created by Felipe Nishino on 25/08/21.
//

import SwiftUI

struct MessageView : View {
    let message : FOAASMessage
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(message.message)
                HStack {
                    Spacer()
                    Text(message.subtitle).italic()
                }
            }
        }
    }
}
