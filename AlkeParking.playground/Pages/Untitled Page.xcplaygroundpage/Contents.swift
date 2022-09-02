import Foundation

protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var date: Date { get }
    var hasDiscountCard: Bool { get set }
    var totalParkedTime: Double { get }
    var fee: Int { get }
}

enum VehicleType {
    case car
    case moto
    case miniBus
    case bus
}

struct Parking {
    var vehicles: Set<Vehicle> = []
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    let type: VehicleType
    let date: Date
    var totalParkedTime: Double
    var hasDiscountCard: Bool
    
    var fee: Int {
        switch type {
        case .car: return 20
        case .moto: return 15
        case .miniBus: return 25
        case .bus: return 30
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}
