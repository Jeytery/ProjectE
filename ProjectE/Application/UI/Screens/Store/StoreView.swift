//
//  StoreView.swift
//  ProjectE
//
//  Created by Jeytery on 29.06.2023.
//

import SwiftUI
import UIKit

class StoreViewViewModel: ObservableObject {
    enum ViewState {
        case error(String)
        case showingPackages([Package])
        case loading
    }
    
    func start() {
        self.state = .loading
        networkingPackageService.getPackages { [self] result in
            switch result {
            case .success(let success):
                self.state = .showingPackages(success)

            case .failure(let failure):
                self.state = .error(failure.localizedDescription)
            }
        }
    }
    
    private let networkingPackageService = NetworkPackageService()
    
    @Published
    private(set) var state: ViewState = .showingPackages([])
    
    @Published
    var isEditing = false
}

struct StoreView: View {
    enum ViewEvent {
        case copiedPackages([AppPackage])
        case choosedPackage(AppPackage)
    }
    
    var outputEventHandler: ((ViewEvent) -> Void)?
    
    init() {
        viewModel.start()
    }
    
    var body: some View {
        content(state: viewModel.state)
    }

    @ObservedObject
    private var viewModel = StoreViewViewModel()
    
    @State
    private var selectedPackages = Set<Package>()
}

private extension StoreView {
    var editButton: some View {
       return Button {
           viewModel.isEditing.toggle()
       } label: {
           if viewModel.isEditing {
               Text("Done")
                   .fontWeight(.semibold)
           } else {
               Text("Copy packages")
           }
       }
    }
    
    func content(state: StoreViewViewModel.ViewState) -> some View {
        switch state {
        case .error(let string): return AnyView(error(string))
        case .showingPackages(let packages): return AnyView(list(packages))
        case .loading: return AnyView(loading())
        }
    }
    
    func list(_ packages: [Package]) -> some View {
        List(
            packages,
            id: \.self,
            selection: $selectedPackages
        ) { package in
            PackageMenuCellView(package: package, withDisclosureIndicator: true, action: {
                outputEventHandler?(
                    .choosedPackage(AppPackage.withPackage(package))
                )
            })
        }
        .environment(
            \.editMode,
             .constant(self.viewModel.isEditing ? EditMode.active : EditMode.inactive)
        )
        
        // TODO: - animations and multichoise
        // i should figure out with this things in v2
        //.animation(.spring())
        //.navigationBarItems(trailing: editButton)
    }
    
    func error(_ errorMessage: String) -> some View {
        VStack {
            Text("Error")
                .font(.title)
            Text(errorMessage)
                .font(.title2)
                .frame(width: UIScreen.main.bounds.width / 2)
                .multilineTextAlignment(.center)
        }
        .navigationBarItems(trailing: Button("Reload") {
            viewModel.start()
        })
    }
    
    func loading() -> some View {
        ProgressView()
            .progressViewStyle(.circular)
            .controlSize(.large)
    }
}

struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
