//
//  ContentView.swift
//  muster-point-patrol
//
//  Created by Rocha Silva, Fernando on 2021-05-13.
//

import Foundation
import SwiftUI
import Combine
import Amplify

struct ContentView: View {
    
    @EnvironmentObject var auth: AuthService
    
    @State var users = [User]()
    
    var postsSubscription: AnyCancellable?
    
    var body: some View {
        VStack{
            Button("Set alert", action: setAlert)
            Spacer()
            List {
                ForEach(users) { user in
                    Text(user.username)
                }
            }
            Spacer()
            Button("Sign Out", action: auth.signOut)
        }.onAppear{
            observeUsers()
        }
    }
    
    func setAlert() {
        Amplify.DataStore.query(User.self) {
            result in
            switch result {
            case . success(let users):
                print(users)
                self.users = [User]()
                self.users = users
            case .failure(let error):
                print(error)
            }
        }
    }

    func observeUsers() {
        _ = Amplify.DataStore.publisher(for: User.self)
            .sink {
                if case let .failure(error) = $0 {
                    print("Subscription received error - \(error.localizedDescription)")
                }
            }
            receiveValue: { changes in
                // handle incoming changes
                print("Subscription received mutation: \(changes)")
            }
    }
    
    init() {
        
    }

}
