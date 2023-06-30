//
//  ContentView.swift
//  ChefDelivery
//
//  Created by ALURA on 17/05/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Attributes
    
    @StateObject private var service = HomeService()
    @State private var storeTypes: [StoreType] = []
    
    @State private var isLoading = true
    
    // MARK: - View
    
    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    NavigationBar()
                        .padding(.horizontal, 15)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            OrderTypeGridView()
                            CarouselTabView()
                            StoresContainerView(stores: storeTypes)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await getStores()
            }
        }
    }
    
    func getStores() async {
        do {
            let result = try await service.fetchData()
            switch result {
            case .success(let stores):
                self.storeTypes = stores
                self.isLoading = false
            case .failure(let error):
                print(error.localizedDescription)
                self.isLoading = false
                break
            }
        } catch {
            print(error.localizedDescription)
            self.isLoading = false
        }
        
        service.fetchDataWithAlamofire { response, error in
            print(response)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
