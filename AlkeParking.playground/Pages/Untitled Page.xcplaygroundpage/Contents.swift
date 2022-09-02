import Foundation

protocol Parkable {
    var plate: String { get }
    // var vehicleType: vehicleType { get }
    var date: Date { get }
    var hasDiscountCard: Bool { get set }
    var totalParkedTime: Double { get }
}

struct Parking {
    var vehicles: Set<Vehicle> = []
}

struct Vehicle: Parkable, Hashable {
    var totalParkedTime: Double
    
    var date: Date
    
    var hasDiscountCard: Bool
    
    let plate: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}
