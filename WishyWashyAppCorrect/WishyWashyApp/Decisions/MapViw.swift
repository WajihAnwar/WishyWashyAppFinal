import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var landmark: Landmark?

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        guard let landmark = landmark else { return }

        let coordinate = CLLocationCoordinate2D(
            latitude: landmark.coordinate.latitude,
            longitude: landmark.coordinate.longitude
        )

        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = landmark.name
        view.addAnnotation(annotation)
    }
}
