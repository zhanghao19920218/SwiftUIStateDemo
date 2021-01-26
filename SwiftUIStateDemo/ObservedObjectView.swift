//
//  ObservedObjectView.swift
//  SwiftUIStateDemo
//
//  Created by Mason on 2021/1/26.
//

import SwiftUI

struct ObservedObjectView: View {
    @ObservedObject private var user = User()
    
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName).")

            TextField("First name", text: $user.firstName)
            TextField("Last name", text: $user.lastName)
        }
    }
}

struct ObservedObjectView_Previews: PreviewProvider {
    static var previews: some View {
        ObservedObjectView()
    }
}
