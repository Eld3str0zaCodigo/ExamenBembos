import SwiftUI

struct DetailView: View {
    let item: ItemModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25) {
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 24).fill(.white)
                    Image(item.imageName).resizable().scaledToFit()
                        .frame(maxWidth: .infinity).frame(height: 285).padding(12)
                        .accessibilityLabel("Hamburguesa \(item.name)")
                    Text("A LA PARRILLA").font(.caption.bold()).tracking(1.2)
                        .padding(.horizontal, 14).padding(.vertical, 9)
                        .background(Brand.yellow, in: Capsule()).padding(16)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.category.uppercased()).font(.caption.bold()).tracking(1.5).foregroundStyle(Brand.blue)
                    Text(item.name.uppercased()).font(Brand.heading(34)).foregroundStyle(Brand.blue)
                    Text(item.subtitle).font(.title3).foregroundStyle(.secondary)
                }
                HStack(alignment: .firstTextBaseline) {
                    Text(item.formattedPrice).font(.largeTitle.bold()).foregroundStyle(Brand.blue)
                    Spacer()
                    Text(item.size).font(.subheadline.bold()).padding(.horizontal, 14).padding(.vertical, 8)
                        .background(Brand.yellow.opacity(0.25), in: Capsule())
                }
                Divider()
                VStack(alignment: .leading, spacing: 12) {
                    Text("EL SABOR ESTÁ EN LOS DETALLES").font(Brand.heading(20))
                    Text(item.description).font(.body).lineSpacing(5).foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 13) {
                    Text("INGREDIENTES").font(Brand.heading(22)).foregroundStyle(Brand.blue)
                    ForEach(item.ingredients, id: \.self) { ingredient in
                        Label {
                            Text(ingredient)
                                .foregroundStyle(Brand.ink)
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                        }
                        .font(.body)
                        .font(.body).foregroundStyle(Brand.ink)
                    }
                }
                Divider()
                attribute("Categoría", value: item.category, icon: "square.grid.2x2")
                attribute("Presentación", value: item.size, icon: "takeoutbag.and.cup.and.straw")
                attribute("Preparación", value: "A la parrilla", icon: "flame")
                Text("Precio, receta y presentación referenciales para el proyecto académico.")
                    .font(.caption).foregroundStyle(.secondary).padding(.bottom, 16)
            }
            .padding(22).frame(maxWidth: 640).frame(maxWidth: .infinity)
        }
        .background(Brand.background).navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline).toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.white, for: .navigationBar)
    }

    private func attribute(_ title: String, value: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).foregroundStyle(Brand.blue).frame(width: 45)
            Text(title).foregroundStyle(.secondary)
            Spacer()
            Text(value).fontWeight(.semibold).multilineTextAlignment(.trailing)
        }
        .font(.subheadline)
    }
}
