import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: SessionStore
    @StateObject private var viewModel = HomeViewModel()
    @State private var confirmLogout = false

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 18) {
                    if viewModel.searchText.isEmpty { hero }
                    HStack {
                        Text("EXPLORA NUESTRO MENÚ").font(Brand.heading(21))
                        Spacer(minLength: 8)
                        Text("\(viewModel.filteredItems.count)")
                            .font(.subheadline.bold()).padding(9)
                            .background(Brand.yellow, in: Circle())
                    }
                    .padding(.top, 8)
                    if viewModel.filteredItems.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "magnifyingglass").font(.largeTitle).foregroundStyle(Brand.blue)
                            Text("No encontramos esa combinación").font(.headline)
                            Text("Prueba con Royal, queso o tocino.").font(.subheadline).foregroundStyle(.secondary)
                            Button("Ver todo el menú") { viewModel.searchText = "" }
                                .font(.headline).padding(.top, 6)
                        }
                        .multilineTextAlignment(.center).frame(maxWidth: .infinity).padding(.vertical, 48)
                    }
                    ForEach(viewModel.filteredItems) { item in
                        NavigationLink(value: item) { ProductRow(item: item) }
                            .buttonStyle(.plain)
                    }
                    Text("Precios e información referenciales para esta demostración.")
                        .font(.caption).foregroundStyle(.secondary).padding(.vertical, 12)
                }
                .padding(20).frame(maxWidth: 720).frame(maxWidth: .infinity)
            }
            .background(Brand.background).scrollDismissesKeyboard(.interactively)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(for: ItemModel.self) { item in DetailView(item: item) }
        .confirmationDialog("¿Cerrar tu sesión?", isPresented: $confirmLogout, titleVisibility: .visible) {
            Button("Cerrar sesión", role: .destructive) { session.logout() }
            Button("Cancelar", role: .cancel) {}
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 12) {
                BrandLogo(white: true).frame(width: 122, height: 45)
                Spacer()
                Button { confirmLogout = true } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.title3).foregroundStyle(.white).frame(width: 44, height: 44)
                }
                .accessibilityLabel("Cerrar sesión")
            }
            Text("Hola, \(session.currentUser?.name ?? "")")
                .font(.subheadline.weight(.medium)).foregroundStyle(.white)
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass").foregroundStyle(Brand.blue)
                TextField("¿Qué quieres hoy?", text: $viewModel.searchText)
                    .autocorrectionDisabled().submitLabel(.search)
                    .accessibilityLabel("Buscar hamburguesas o ingredientes")
                if !viewModel.searchText.isEmpty {
                    Button { viewModel.searchText = "" } label: {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Limpiar búsqueda")
                }
            }
            .padding(16).background(.white, in: RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal, 22).padding(.top, 8).padding(.bottom, 22)
        .background(Brand.blue.ignoresSafeArea(edges: .top))
    }

    private var hero: some View {
        HStack(spacing: 4) {
            VStack(alignment: .leading, spacing: 10) {
                Text("A LA PARRILLA").font(.caption.bold()).tracking(1.8).foregroundStyle(Brand.yellow)
                Text("TU ANTOJO,\nTU BEMBOS.")
                    .font(Brand.heading(27)).foregroundStyle(.white).fixedSize(horizontal: false, vertical: true)
                Capsule().fill(Brand.red).frame(width: 55, height: 6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image("royal").resizable().scaledToFit()
                .frame(maxWidth: 170).accessibilityHidden(true)
        }
        .padding(19).frame(minHeight: 180)
        .background(Brand.blue, in: RoundedRectangle(cornerRadius: 20))
    }
}

struct ProductRow: View {
    let item: ItemModel
    var body: some View {
        HStack(spacing: 14) {
            Image(item.imageName).resizable().scaledToFit()
                .frame(width: 112, height: 112).accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 7) {
                Text(item.name).font(.title3.bold()).foregroundStyle(Brand.blue)
                Text(item.subtitle).font(.subheadline).foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(item.formattedPrice).font(.headline).foregroundStyle(Brand.ink)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right").font(.caption.bold()).foregroundStyle(Brand.blue)
        }
        .padding(14).frame(maxWidth: .infinity, alignment: .leading)
        .background(.white, in: RoundedRectangle(cornerRadius: 17))
        .overlay(RoundedRectangle(cornerRadius: 17).stroke(Brand.blue.opacity(0.07)))
        .accessibilityElement(children: .combine)
    }
}
