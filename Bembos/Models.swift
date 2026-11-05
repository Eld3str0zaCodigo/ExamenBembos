import Foundation

struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
    let email: String
}

// Value model passed directly through NavigationLink to DetailView.
struct ItemModel: Identifiable, Hashable {
    let id: String
    let name: String
    let subtitle: String
    let imageName: String
    let price: Double
    let category: String
    let size: String
    let ingredients: [String]
    let description: String

    var formattedPrice: String {
        String(format: "S/ %.2f", locale: Locale(identifier: "es_PE"), price)
    }
}

extension ItemModel {
    // Academic sample data: prices, portions and recipes are illustrative.
    static let catalog: [ItemModel] = [
        .init(id: "clasica", name: "Clásica", subtitle: "El sabor de siempre, a la parrilla.", imageName: "clasica", price: 15.90, category: "Las clásicas", size: "Regular", ingredients: ["Carne a la parrilla", "Lechuga", "Tomate", "Mayonesa"], description: "Una combinación sencilla para disfrutar el sabor de la parrilla. Pan suave, vegetales y una hamburguesa con personalidad."),
        .init(id: "royal", name: "Royal", subtitle: "Huevo y queso para una gran combinación.", imageName: "royal", price: 19.90, category: "Las clásicas", size: "Regular", ingredients: ["Carne a la parrilla", "Huevo", "Queso Edam", "Lechuga", "Tomate", "Mayonesa"], description: "El huevo y el queso se encuentran con la carne a la parrilla. Una combinación llena de sabor para cuando quieres algo especial."),
        .init(id: "quesoTocino", name: "Queso Tocino", subtitle: "Queso fundido y un toque ahumado.", imageName: "quesoTocino", price: 20.90, category: "Las clásicas", size: "Regular", ingredients: ["Carne a la parrilla", "Queso Edam", "Tocino", "Lechuga", "Tomate", "Mayonesa"], description: "La intensidad del tocino y la suavidad del queso acompañan a nuestra hamburguesa a la parrilla. Una favorita para los amantes del sabor ahumado."),
        .init(id: "hawaiana", name: "Hawaiana", subtitle: "Un encuentro entre lo dulce y lo salado.", imageName: "hawaiana", price: 20.90, category: "Especialidades", size: "Regular", ingredients: ["Carne a la parrilla", "Piña", "Jamón", "Queso", "Mayonesa"], description: "La piña aporta un toque dulce a esta combinación con jamón y queso. Una hamburguesa con un giro tropical."),
        .init(id: "aLoPobre", name: "A lo Pobre", subtitle: "Una combinación con espíritu peruano.", imageName: "aLoPobre", price: 22.90, category: "Especialidades", size: "Regular", ingredients: ["Carne a la parrilla", "Huevo", "Plátano frito", "Cebolla", "Mayonesa"], description: "Inspirada en una combinación peruana muy querida. Huevo y plátano frito acompañan la carne a la parrilla en un bocado lleno de contrastes."),
        .init(id: "cheese", name: "Cheese", subtitle: "Para quienes siempre eligen queso.", imageName: "cheese", price: 17.90, category: "Las clásicas", size: "Regular", ingredients: ["Carne a la parrilla", "Queso", "Lechuga", "Tomate", "Mayonesa"], description: "Todo el protagonismo del queso sobre una hamburguesa a la parrilla. Una opción sencilla y sabrosa para disfrutar a tu ritmo."),
        .init(id: "parrillera", name: "Parrillera", subtitle: "Sabor intenso en cada bocado.", imageName: "parrillera", price: 23.90, category: "Especialidades", size: "Regular", ingredients: ["Carne a la parrilla", "Chorizo", "Queso", "Lechuga", "Mayonesa"], description: "Una propuesta para quienes disfrutan de sabores intensos. La carne y el chorizo se unen con queso y vegetales en pan suave."),
        .init(id: "extrema", name: "Extrema", subtitle: "Más capas, más sabor a la parrilla.", imageName: "extrema", price: 25.90, category: "Especialidades", size: "Regular", ingredients: ["Carne a la parrilla", "Tocino", "Queso", "Huevo", "Lechuga", "Mayonesa"], description: "Una combinación abundante con carne, queso, tocino y huevo. Pensada para esos días en los que quieres disfrutar una hamburguesa con todo.")
    ]
}
