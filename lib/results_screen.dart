import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    if (provider.places.isNotEmpty) {
      _markers = provider.places.map((place) => Marker(
        markerId: MarkerId(place.name),
        position: LatLng(place.lat, place.lng),
        infoWindow: InfoWindow(title: place.name, snippet: place.vicinity),
      )).toSet();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recommendations')),
      body: provider.error.isNotEmpty
          ? Center(child: Text(provider.error))
          : Column(
              children: [
                SizedBox(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 10), // Default; update with user loc
                    onMapCreated: (controller) => _mapController = controller,
                    markers: _markers,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.places.length,
                    itemBuilder: (_, i) {
                      final place = provider.places[i];
                      return ListTile(
                        title: Text(place.name),
                        subtitle: Text(place.vicinity),
                        onTap: () => _mapController.animateCamera(CameraUpdate.newLatLng(LatLng(place.lat, place.lng))),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
