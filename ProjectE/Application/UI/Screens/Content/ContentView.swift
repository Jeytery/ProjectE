//
//  ContentView.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Text("Nothing")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.secondary)
                Text("Choose option from menu")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .frame(height: 100)
            Spacer()
        }
        .background(Color.gray.opacity(0.1))
        .frame(width: 260)
        .cornerRadius(12)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
