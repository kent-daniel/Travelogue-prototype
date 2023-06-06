struct PlaceData: Codable {
    let type: String
    let id: String
    let geometry: GeometryData
    let properties: PropertiesData
}

struct GeometryData: Codable {
    let type: String
    let coordinates: [Double]
}

struct PropertiesData: Codable {
    let xid: String
    let name: String
    let dist: Double
    let rate: Int
    let osm: String
    let wikidata: String?
    let kinds: String
}

struct PlacesResponseData: Codable {
    let type: String
    let features: [PlaceData]
}


struct PlaceDetailsData: Codable {
    let xid: String
    let address: AddressData?
}

struct AddressData: Codable {
    let road: String?
    let suburb: String?
    let state: String?
    let house_number:String?
}
