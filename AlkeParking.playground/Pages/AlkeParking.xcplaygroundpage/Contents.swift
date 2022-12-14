import Foundation

// MARK: - Protocols
protocol Parkable {
    var plate: String { get }
    var type: VehicleType { get }
    var checkInTime: Date { get }
    var discountCard: String? { get set }
    // tiempo en minutos
    var parkedTime: Int { get }
}

// MARK: - Enums
enum VehicleType {
    case car
    case moto
    case miniBus
    case bus
    
    var fee: Int {
        switch self {
        case .car: return 20
        case .moto: return 15
        case .miniBus: return 25
        case .bus: return 30
        }
    }
}

// MARK: - Structs
struct Parking {
    private var vehicles: Set<Vehicle> = []
    private let maxCapacity: Int = 20
    private var vehiclesOutEarnings: (vehicles: Int, earnings: Int) = (0,0)
    
    /* La función es definida como mutating
     pues al estar modificando una propiedad de una struct
     debe indicarse explícitamente que se desea que la instancia sea modificada. */
    mutating func checkInVehicle(_ vehicle: Vehicle, onFinish: (Bool) -> Void) {
        guard vehicles.count < maxCapacity, vehicles.insert(vehicle).inserted else {
            onFinish(false)
            print("Sorry, the check-in failed")
            return
        }
        print("Welcome to AlkeParking!")
        onFinish(true)
    }
    
    mutating func checkOutVehicle(plate: String,
                         onSuccess: (Int) -> Void,
                         onError: () -> Void ) {
        guard let vehicleIn = vehicles.first(where: { vehicle in
            vehicle.plate == plate
        }) else {
            onError()
            return
        }
        
        let hasDiscountCard: Bool = vehicleIn.discountCard?.isEmpty != nil
        let totalFee = calculateFee(for: vehicleIn.type, parkedTime: vehicleIn.parkedTime, hasDiscountCard: hasDiscountCard)
        
        vehiclesOutEarnings.vehicles += 1
        vehiclesOutEarnings.earnings += totalFee
        
        onSuccess(totalFee)
        vehicles.remove(vehicleIn)
    }
    
    private func calculateFee(for type: VehicleType, parkedTime: Int, hasDiscountCard: Bool) -> Int {
        // valor inicial de 2hrs
        var fee = type.fee
        print("initial fee", fee)
        
        // tiempo extra mayor a 2hrs
        if parkedTime > 120 {
            let extraTime = parkedTime - 120
            let extraFee = ceil(Double(extraTime) / 15) * 5
            
            fee += Int(extraFee)
        }
        
        if hasDiscountCard {
            fee = Int(Double(fee) * 0.85)
            print("15% discount applied!")
        }
        
        return fee
    }
    
    func earnings() {
        print("\(vehiclesOutEarnings.vehicles) vehicles have checked out and have earnings of $\(vehiclesOutEarnings.earnings)")
    }
    
    func listVehicles() {
        for vehicle in vehicles {
            print("Plate", vehicle.plate)
        }
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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(plate)
    }
    
    static func ==(lhs: Vehicle, rhs: Vehicle) -> Bool {
        return lhs.plate == rhs.plate
    }
}

// MARK: - Instances
var alkeParking = Parking()

let vehicles = [
    Vehicle(plate: "AA111AA",
                           type: VehicleType.car,
                           checkInTime: Date(),
                           discountCard: "DISCOUNT_CARD_001"),
    Vehicle(plate: "B222BBB",
                           type: VehicleType.moto,
                           checkInTime: Date(),
                           discountCard: nil),
    Vehicle(plate: "CC333CC",
                           type: VehicleType.miniBus,
                           checkInTime: Date(),
                           discountCard: nil),
    Vehicle(plate: "DD444DD",
                           type: VehicleType.bus,
                           checkInTime: Date(),
                           discountCard: "DISCOUNT_CARD_002"),
    Vehicle(plate: "AA111BB",
                           type: VehicleType.car,
                           checkInTime: Date(),
                           discountCard: "DISCOUNT_CARD_003"),
    Vehicle(plate: "B222CCC",
                           type: VehicleType.moto,
                           checkInTime: Date(),
                           discountCard: "DISCOUNT_CARD_004"),
    Vehicle(plate: "CC333DD",
                           type: VehicleType.miniBus,
                           checkInTime: Date(),
                           discountCard: nil),
    Vehicle(plate: "DD444EE",
                           type: VehicleType.bus,
                           checkInTime: Date(),
                           discountCard: "DISCOUNT_CARD_005"),
    Vehicle(plate: "AA111CC",
                           type: VehicleType.car,
                           checkInTime: Date(),
                           discountCard: nil),

    Vehicle(plate: "B222DDD",
                            type: VehicleType.moto,
                            checkInTime: Date(),
                            discountCard: nil),

    Vehicle(plate: "CC333EE",
                            type: VehicleType.miniBus,
                            checkInTime: Date(),
                            discountCard: nil),

    Vehicle(plate: "DD444GG",
                            type: VehicleType.bus,
                            checkInTime: Date(),
                            discountCard: "DISCOUNT_CARD_006"),

    Vehicle(plate: "AA111DD",
                            type: VehicleType.car,
                            checkInTime: Date(),
                            discountCard: "DISCOUNT_CARD_007"),

    Vehicle(plate: "B222EEE",
                            type: VehicleType.moto,
                            checkInTime: Date(),
                            discountCard: nil),

    Vehicle(plate: "CC333FF",
                            type: VehicleType.bus,
                            checkInTime: Date(),
                            discountCard: nil),
    Vehicle(plate: "D222DDD",
                            type: VehicleType.moto,
                            checkInTime: Date(),
                            discountCard: nil),

    Vehicle(plate: "DC333EE",
                            type: VehicleType.miniBus,
                            checkInTime: Date(),
                            discountCard: nil),

    Vehicle(plate: "DD444GG",
                            type: VehicleType.bus,
                            checkInTime: Date(),
                            discountCard: "DISCOUNT_CARD_006"),

    Vehicle(plate: "EA111DD",
                            type: VehicleType.car,
                            checkInTime: Date(),
                            discountCard: "DISCOUNT_CARD_007"),

    Vehicle(plate: "E222EEE",
                            type: VehicleType.moto,
                            checkInTime: Date(),
                            discountCard: nil),

    Vehicle(plate: "EC333FF",
                            type: VehicleType.miniBus,
                            checkInTime: Date(),
                            discountCard: nil)
]

for vehicle in vehicles {
    alkeParking.checkInVehicle(vehicle) { success in
        if success {
            print("Welcome to AlkeParking!")
        } else {
            print("Sorry, the check-in failed", vehicle.plate)
        }
    }
}

alkeParking.checkOutVehicle(plate: "CC333FF") { fee in
    print("Your fee is \(fee). Come back soon.")
} onError: {
    print("Sorry, the check-out failed")
}

alkeParking.checkOutVehicle(plate: "AA111BB") { fee in
    print("Your fee is \(fee). Come back soon.")
} onError: {
    print("Sorry, the check-out failed")
}

alkeParking.checkOutVehicle(plate: "CC333DD") { fee in
    print("Your fee is \(fee). Come back soon.")
} onError: {
    print("Sorry, the check-out failed")
}

alkeParking.earnings()
alkeParking.listVehicles()
