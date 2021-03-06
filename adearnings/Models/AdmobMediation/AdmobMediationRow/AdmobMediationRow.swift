import Foundation

struct AdmobMediationRow: Encodable, Decodable {
    init(dimensionValue: DimensionValue, metricValue: MetricValue) {
        self.dimensionValue = dimensionValue
        self.metricValue = metricValue
    }
    
    var dimensionValue: DimensionValue
    var metricValue: MetricValue
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dimensionValue = try values.decode(DimensionValue.self, forKey: .dimensionValue)
        metricValue = try values.decode(MetricValue.self, forKey: .metricValue)
    }
    
    enum CodingKeys: String, CodingKey {
        case dimensionValue, metricValue
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dimensionValue, forKey: .dimensionValue)
        try container.encode(metricValue, forKey: .metricValue)
    }
    
    static func fromDict(json: [String: Any], metric: Metric = Metric.ESTIMATED_EARNINGS) -> AdmobMediationRow? {
        guard let dimensionValues = json["dimensionValues"] as? [String: Any],
              let metricValues = json["metricValues"] as? [String: Any]
        else {
            return nil
        }
        
        guard let dimensionKey = dimensionValues.first?.key,
              let dimensionVal = dimensionValues.first?.value as? [String: Any],
              let metricKey = metricValues.first?.key,
              let metricVal = metricValues.first?.value as? [String: Any]
        else {
            return nil
        }
        
        guard let dimensionValue = dimensionVal["value"] as? String else {
            return nil
        }
        
        var metricValue: Double
        
        if(metric == Metric.CLICKS) {
            metricValue = Double((metricVal["integerValue"] as? NSString)?.integerValue ?? 0)
        }
        else {
            metricValue = ((metricVal["microsValue"] as? NSString)?.doubleValue ?? 0) / 1_000_000
        }
        
        if let dimensionLabel = dimensionVal["displayLabel"] as? String {
            return AdmobMediationRow(
                dimensionValue: DimensionValue(
                    dimension: dimensionKey,
                    value: dimensionValue,
                    displayLabel: dimensionLabel
                ),
                metricValue: MetricValue(
                    metric: metricKey,
                    value: metricValue.rounded(toPlaces: 2)
                )
            )
        }
        return AdmobMediationRow(
            dimensionValue: DimensionValue(
                dimension: dimensionKey,
                value: dimensionValue
            ),
            metricValue: MetricValue(
                metric: metricKey,
                value: metricValue.rounded(toPlaces: 2)
            )
        )
    }
}
