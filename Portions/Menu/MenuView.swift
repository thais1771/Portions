//
//  MenuView.swift
//  Portions
//
//  Created by Thais Rodríguez on 18/8/23.
//

import ComposableArchitecture
import SwiftUI

struct MenuView: View {
    let store: StoreOf<Menu>

    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            VStack {
                Form {
                    Section {
                        ForEach(viewStore.options) { option in
                            Button(action: option.action) {
                                HStack {
                                    if let icon = option.icon {
                                        Image(systemName: icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:35, height: 20)
                                    }
                                    Text(option.title.capitalized)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                            }
                        }
                    }
                    Section {
                        ShareLink("Share \"Portions\"", item: "https://apps.apple.com/es/app/lactapp/id1040787494", message: Text("Quiero compartir contigo \"Portions\""))
                        HStack {
                            Spacer()
                            Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                                .foregroundColor(.secondary)
                                .font(.system(size: 13))
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(
            store: Store(initialState: Menu.State()) {
                Menu()
            }
        )
    }
}
