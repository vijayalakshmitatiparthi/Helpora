import SwiftUI

struct HelpService: Identifiable, Hashable {
    let id: String
    let title: String
    let emoji: String
    let description: String
    let price: Int
}

private let demoServices: [HelpService] = [
    .init(id: "errands", title: "Quick Errands", emoji: "🛍️", description: "Shopping and small errands", price: 199),
    .init(id: "delivery", title: "Pickup & Drop", emoji: "📦", description: "Local pickup and delivery", price: 149),
    .init(id: "hospital", title: "Hospital Help", emoji: "🏥", description: "Assistance at appointments", price: 299),
    .init(id: "queue", title: "Queue Assistant", emoji: "🎟️", description: "Help standing in line", price: 179),
    .init(id: "senior", title: "Senior Support", emoji: "💜", description: "Non-medical senior assistance", price: 349),
    .init(id: "custom", title: "Custom Task", emoji: "✨", description: "Your own request", price: 249)
]

struct HelpBooking: Identifiable {
    let id = UUID()
    let service: HelpService
    let task: String
    let address: String
    let when: Date
}

@MainActor final class DemoStore: ObservableObject {
    @Published var bookings: [HelpBooking] = []
    func add(_ booking: HelpBooking) { bookings.insert(booking, at: 0) }
}

private enum Theme {
    static let indigo = Color(red: 0.30, green: 0.39, blue: 0.94)
    static let ink = Color(red: 0.10, green: 0.15, blue: 0.26)
    static let pale = Color(red: 0.93, green: 0.95, blue: 1.0)
}

@main
struct HelporaApp: App {
    @StateObject private var store = DemoStore()
    var body: some Scene {
        WindowGroup {
            MainTabs()
                .environmentObject(store)
                .tint(Theme.indigo)
        }
    }
}

struct MainTabs: View {
    var body: some View {
        TabView {
            HomeScreen()
                .tabItem { Label("Home", systemImage: "house.fill") }
            BookingsScreen()
                .tabItem { Label("Bookings", systemImage: "calendar") }
            WalletScreen()
                .tabItem { Label("Wallet", systemImage: "creditcard") }
            ProfileScreen()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
    }
}

struct HomeScreen: View {
    @State private var selectedService: HelpService?
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 11), count: 3)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Good day 👋").foregroundStyle(.secondary).font(.caption)
                            Text("What needs doing?").font(.system(size: 27, weight: .bold, design: .rounded))
                        }
                        Spacer()
                        Text("😊").font(.largeTitle).padding(10).background(Theme.pale, in: RoundedRectangle(cornerRadius: 15))
                    }
                    Label("Demo location · Bengaluru", systemImage: "location.fill")
                        .font(.footnote.weight(.semibold)).foregroundStyle(.secondary)
                    HStack {
                        VStack(alignment: .leading, spacing: 7) {
                            Text("More time for\nwhat matters.")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Text("One booking away from a helping hand.")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("🙋🏽‍♀️").font(.system(size: 72))
                    }
                    .padding(20)
                    .background(Theme.pale, in: RoundedRectangle(cornerRadius: 21))

                    Text("What can we help with?")
                        .font(.title3.bold())
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(demoServices) { service in
                            Button { selectedService = service } label: {
                                VStack(spacing: 10) {
                                    Text(service.emoji).font(.system(size: 30))
                                        .frame(width: 56, height: 55)
                                        .background(Theme.pale, in: RoundedRectangle(cornerRadius: 15))
                                    Text(service.title).font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(Theme.ink).multilineTextAlignment(.center)
                                        .frame(height: 30, alignment: .top)
                                }
                                .frame(maxWidth: .infinity).padding(.vertical, 13)
                                .background(.white, in: RoundedRectangle(cornerRadius: 17))
                                .overlay(RoundedRectangle(cornerRadius: 17).stroke(.gray.opacity(0.13)))
                            }
                        }
                    }
                    Text("Need help today?").font(.title3.bold())
                    Button { selectedService = demoServices[5] } label: {
                        HStack(spacing: 13) {
                            Text("⚡").font(.largeTitle)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Quick booking").font(.headline)
                                Text("Start from ₹149").font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("Book →").font(.callout.bold())
                        }
                        .padding().background(Theme.pale.opacity(0.6), in: RoundedRectangle(cornerRadius: 15))
                    }
                }.padding(21)
            }
            .background(Color(red: 0.98, green: 0.985, blue: 1.0))
            .sheet(item: $selectedService) { service in
                BookingSheet(service: service)
            }
        }
    }
}

struct BookingSheet: View {
    let service: HelpService
    @EnvironmentObject private var store: DemoStore
    @Environment(\.dismiss) private var dismiss
    @State private var task = ""
    @State private var address = ""
    @State private var when = Date()
    @State private var submitted = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text(service.emoji).font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(service.title).font(.headline)
                            Text(service.description).font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("₹\(service.price)").font(.headline).foregroundStyle(Theme.indigo)
                    }
                }
                Section("Task details") {
                    TextField("What do you need help with?", text: $task, axis: .vertical)
                        .lineLimit(2...5)
                    TextField("Service address", text: $address, axis: .vertical)
                        .lineLimit(1...3)
                    DatePicker("Preferred time", selection: $when, in: Date()...)
                }
                Section {
                    Button {
                        store.add(.init(service: service, task: task, address: address, when: when))
                        submitted = true
                    } label: {
                        Text("Confirm demo booking · ₹\(service.price)")
                            .fontWeight(.bold).frame(maxWidth: .infinity)
                    }
                    .disabled(task.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                } footer: {
                    Text("Demo only. No real helper or payment is involved.")
                }
            }
            .navigationTitle("Book a helper")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Close") { dismiss() } } }
            .alert("Booking confirmed!", isPresented: $submitted) {
                Button("Done") { dismiss() }
            } message: { Text("Your sample booking has been added under Bookings.") }
        }
    }
}

struct BookingsScreen: View {
    @EnvironmentObject private var store: DemoStore
    var body: some View {
        NavigationStack {
            Group {
                if store.bookings.isEmpty {
                    ContentUnavailableView("No bookings yet", systemImage: "calendar.badge.plus", description: Text("Book any service from the Home tab to try the demo."))
                } else {
                    List(store.bookings) { booking in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(booking.service.emoji)
                                Text(booking.service.title).font(.headline)
                                Spacer()
                                Text("Demo").font(.caption.bold()).foregroundStyle(.green)
                            }
                            Text(booking.task).font(.subheadline)
                            Text(booking.address).font(.caption).foregroundStyle(.secondary)
                            Text(booking.when, style: .date).font(.caption).foregroundStyle(.secondary)
                            Text("₹\(booking.service.price)").font(.subheadline.bold())
                        }.padding(.vertical, 7)
                    }
                }
            }.navigationTitle("My bookings")
        }
    }
}

struct WalletScreen: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Demo wallet balance").font(.subheadline).foregroundStyle(.white.opacity(0.75))
                    Text("₹0.00").font(.system(size: 40, weight: .bold, design: .rounded)).foregroundStyle(.white)
                    Text("No real payment method linked").font(.caption).foregroundStyle(.white.opacity(0.7))
                }.frame(maxWidth: .infinity, alignment: .leading).padding(25)
                    .background(Theme.ink, in: RoundedRectangle(cornerRadius: 20))
                Label("Cards and UPI can be connected later", systemImage: "creditcard")
                    .foregroundStyle(.secondary)
                Spacer()
            }.padding().navigationTitle("Wallet")
        }
    }
}

struct ProfileScreen: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("😊").font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text("Demo Guest").font(.headline)
                            Text("No sign in required").font(.caption).foregroundStyle(.secondary)
                        }
                    }.padding(.vertical, 9)
                }
                Section("Account") {
                    Label("Saved addresses · Demo", systemImage: "mappin")
                    Label("Notifications · Demo", systemImage: "bell")
                    Label("Safety & support · Demo", systemImage: "shield")
                }
                Section {
                    Text("Helpora prototype · Version 0.1")
                        .foregroundStyle(.secondary).font(.caption)
                }
            }.navigationTitle("Profile")
        }
    }
}
