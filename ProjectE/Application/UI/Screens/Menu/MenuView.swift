//
//  MenuView.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import SwiftUI

fileprivate enum ViewState {
    case error(String)
    case empty
    case showingPackages(FormattedAppPackages)
}

class MenuViewViewModel: ObservableObject {
    @Published fileprivate var viewState: ViewState = .error("Empty")
}

struct MenuView: View {
    
    enum OutputEvent {
        case finished
        case tapSettings
        case tapDiscover
        
        case choosedPackage(AppPackage)
    }
    
    var outputEventHandler: ((OutputEvent) -> Void)?

    init() {
        let result = packageDeviceStorageService.getAppPackages()
        switch result {
        case .success(let success):
            self.packageFormatter = PackageFormatter(appPackages: success)
            self.viewModel.viewState = .showingPackages(packageFormatter.getFormattedPackages())
        
        case .failure(let failure):
            self.packageFormatter = PackageFormatter(appPackages: [])
            if failure != .nilInStorageByKey, failure != .failedToParsePackages {
                self.viewModel.viewState = .error(failure.localizedDescription)
            }
            else {
                self.viewModel.viewState = .showingPackages(packageFormatter.getFormattedPackages())
            }
        }
    }
    
    var body: some View {
        content(state: viewModel.viewState)
    }
    
    @ObservedObject private var viewModel = MenuViewViewModel()
    private var packageFormatter: PackageFormatter!
    private let packageDeviceStorageService = PackageDeviceStorageService()
}

private extension MenuView {
    func ErrorCell(message: String) -> some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.white)
                    .onTapGesture {
                        self.viewModel.viewState = .showingPackages(self.packageFormatter.getFormattedPackages())
                    }
            }
            Text(message)
                .foregroundColor(.white)
        }
    }
    
    func AppPackageCell(_ appPackage: AppPackage) -> some View {
        PackageMenuCellView(appPackage: appPackage, withDisclosureIndicator: true, action: {
            packageFormatter.openPackage(appPackage)
            if let error = packageDeviceStorageService.saveAppPackages(packageFormatter.appPackages) {
                self.viewModel.viewState = .error(error.localizedDescription)
                return
            }
            self.viewModel.viewState = .showingPackages(packageFormatter.getFormattedPackages())
            outputEventHandler?(.choosedPackage(appPackage))
        })
    }
    
    func showingPackages(
        _ formatedAppPackages: FormattedAppPackages,
        withError: String? = nil
    ) -> some View {
        List {
            if let withError = withError {
                Section {
                    ErrorCell(message: withError)
                }
                .listRowBackground(Rectangle().foregroundColor(.red))
            }
            
            Section(
                footer: Text("Download free packages from the community")
            ) {
                Button {
                    outputEventHandler?(.tapDiscover)
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "globe.europe.africa.fill")
                        Text("Discover packages")
                            .foregroundColor(.blue)
                            .font(.system(size: 17, weight: .medium, design: .default))
                        Spacer()
                    }
                }
                .listRowBackground(Color.blue.opacity(0.1))
            }
            
            if !formatedAppPackages.pinnedPackages.isEmpty {
                Section(header: Text("Pinned")) {
                    ForEach(
                        formatedAppPackages.pinnedPackages,
                        id: \.self
                    ) { value in
                        AppPackageCell(value)
                    }
                }
            }
            
            if !formatedAppPackages.lastOpenedPackages.isEmpty {
                Section(header: Text("Last opened")) {
                    ForEach(
                        formatedAppPackages.lastOpenedPackages,
                        id: \.self
                    ) { value in
                        AppPackageCell(value)
                    }
                }
            }
           
            if !formatedAppPackages.allLeftPackages.isEmpty {
                ForEach(
                    formatedAppPackages.allLeftPackages,
                    id: \.self
                ) { value in
                    AppPackageCell(value)
                }
                .onDelete {
                    value in
                    self.packageFormatter.appPackages.remove(atOffsets: value)
                    savePackages(self.packageFormatter.appPackages)
                    self.viewModel.viewState = .showingPackages(self.packageFormatter.getFormattedPackages())
                }
            }
            else {
                Section(
                    header: Text("All packages"),
                    footer: Text("This section contains you packages")
                ) {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Empty")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.secondary)
                            Text("Add packages from the store")
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        .frame(height: 100)
                        Spacer()
                    }
                    .listRowBackground(Color.gray.opacity(0.1))
                }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Button {
                    self.outputEventHandler?(.tapSettings)
                } label: {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    
    func content(state: ViewState) -> some View {
        switch state {
        case .error(let string):
            let view = showingPackages(
                self.packageFormatter.getFormattedPackages(),
                withError: string
            )
            return AnyView(view)
        case .empty:
            return AnyView(Text(""))
        case .showingPackages(let formatedAppPackages):
            return AnyView(self.showingPackages(formatedAppPackages))
        }
    }
}

extension MenuView {
    private func savePackages(_ packages: [AppPackage]) {
        if let error = self.packageDeviceStorageService.saveAppPackages(packages) {
            return self.viewModel.viewState = .error(error.localizedDescription)
        }
        self.viewModel.viewState = .showingPackages(packageFormatter.getFormattedPackages())
    }
    
    func addPackage(_ package: AppPackage) {
        if
            !self.packageFormatter.appPackages
            .filter({ $0.id == package.id })
            .isEmpty
        {
            self.viewModel.viewState = .error("You already have this package")
            return
        }
        self.packageFormatter.appPackages.append(package)
        savePackages(self.packageFormatter.appPackages)
    }
    
    func addPackages(_ packages: [AppPackage]) {
        self.packageFormatter.appPackages.append(contentsOf: packages)
        savePackages(self.packageFormatter.appPackages)
    }
    
    func updatePackage(_ appPackage: AppPackage) {
        self.packageFormatter.updatePackage(appPackage)
        savePackages(self.packageFormatter.appPackages)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
