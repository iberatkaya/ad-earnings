import SwiftUI

struct ContentView: View {
    @ObservedObject var googleDelegate: GoogleDelegate
    
    var connectivityController: ConnectivityController
    
    init(googleDelegate: GoogleDelegate) {
        self.googleDelegate = googleDelegate
        connectivityController = ConnectivityController(googleDelegate: googleDelegate)
        self.googleDelegate.connectivityController = connectivityController
    }
    
    var body: some View {
        HomeView().environmentObject(googleDelegate)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var delegate = GoogleDelegate()
    
    static var previews: some View {
        ContentView(googleDelegate: delegate)
    }
}
