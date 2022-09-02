import Foundation

// MARK: - Protocols
protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get set }
    var parkedTime: Int { get }
    var fee: Int { get }
}

// MARK: - Enums
enum VehicleType {
    case car
    case moto
    case miniBus
    case bus
}

// MARK: - Structs
struct Parking {
    var vehicles: Set<Vehicle> = []
    
    /* La función es definida como mutating pues al estar modificando una propiedad de una struct debe indicarse explícitamente que se desea que la instancia sea modificada. */
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        
    }
}

struct Vehicle: Parkable, Hashable {
    let plate: String
    let type: VehicleType
    let checkInTime: Date
    
    var parkedTime: Int {
        return Calendar.current.dateComponents([.minute], from: checkInTime, to: Date()).minute ?? 0
    }
    
    var discountCard: String?
    
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

// MARK: - Instances
var alkeParking = Parking()

let car = Vehicle(plate: "AA111AA", type: VehicleType.car, checkInTime: Date(), discountCard: "DISCOUNT_CARD_001")
let car2 = Vehicle(plate: "AA111AA", type: VehicleType.car,
checkInTime: Date(), discountCard: "DISCOUNT_CARD_003")
let moto = Vehicle(plate: "B222BBB", type: VehicleType.moto, checkInTime: Date(), discountCard: nil)
let miniBus = Vehicle(plate: "CC333CC", type: VehicleType.miniBus, checkInTime: Date(), discountCard:

nil)
let bus = Vehicle(plate: "DD444DD", type: VehicleType.bus, checkInTime: Date(), discountCard: "DISCOUNT_CARD_002")

alkeParking.vehicles.insert(car)
alkeParking.vehicles.insert(car2)
alkeParking.vehicles.insert(moto)
alkeParking.vehicles.insert(miniBus)
alkeParking.vehicles.insert(bus)

alkeParking.vehicles.remove(moto)
