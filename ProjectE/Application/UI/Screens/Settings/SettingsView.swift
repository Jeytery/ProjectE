//
//  SettingsView.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import SwiftUI
import SettingsIconGenerator
import UIKit

struct SettingsView: View {
    var body: some View {
        Form {
            Section(footer: Text("from Kyiv with love")) {
                HStack {
                    Image(uiImage: UIImage.generateSettingsIcon("1.circle.fill", backgroundColor: .systemBlue)!)
                    Text("Version")
                    Spacer()
                    Text("v1")
                        .foregroundColor(.gray)
                }
                ZStack  {
                    HStack {
                        Image(uiImage: UIImage.generateSettingsIcon("person.crop.circle", backgroundColor: .systemRed)!)
                        Text("Author")
                        Spacer()
                        Text("Jeytery")
                            .foregroundColor(.gray)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                    Button("") {
                        guard let url = URL(string: "https://telegram.im/@Jeytery") else { return }
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
