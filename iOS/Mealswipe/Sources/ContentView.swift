import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false

    @State private var draftNote: String = ""
    @State private var draftSwipesUsed: Int = 0
    @State private var draftDollarsSpent: Double = 0.0

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                List {
                    ForEach(store.items) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.note)
                                .font(Theme.bodyFont)
                                .foregroundStyle(.primary)
                            if !("swipesUsed: \(item.swipesUsed)" + " · " + "dollarsSpent: \(item.dollarsSpent)".isEmpty) {
                                Text("swipesUsed: \(item.swipesUsed)" + " · " + "dollarsSpent: \(item.dollarsSpent)")
                                    .font(Theme.captionFont)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .listRowBackground(Theme.cardBackground)
                    }
                    .onDelete { offsets in
                        store.delete(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Mealswipe")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAddMore {
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                addSheet
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
                    .environmentObject(purchases)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
                    .environmentObject(store)
                    .environmentObject(purchases)
            }
        }
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                TextField("Note", text: $draftNote)
                    .accessibilityIdentifier("field_note")
                TextField("Swipesused", value: $draftSwipesUsed, format: .number)
                    .keyboardType(.numberPad)
                    .accessibilityIdentifier("field_swipesUsed")
                TextField("Dollarsspent", value: $draftDollarsSpent, format: .number)
                    .keyboardType(.decimalPad)
                    .accessibilityIdentifier("field_dollarsSpent")
            }
            .navigationTitle("Add Log")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAdd = false
                    }
                    .accessibilityIdentifier("cancelAddButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = Log(note: draftNote, swipesUsed: draftSwipesUsed, dollarsSpent: draftDollarsSpent)
                        store.add(item)
                        resetDraft()
                        showingAdd = false
                    }
                    .accessibilityIdentifier("saveAddButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    private func resetDraft() {
        draftNote = ""
        draftSwipesUsed = 0
        draftDollarsSpent = 0.0
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
