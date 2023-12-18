import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homenom/services/order_controller.dart';
import 'package:homenom/services/user_controller.dart';
import 'package:provider/provider.dart';
import '../structure/Order.dart' as order_class;

class TransitScreen extends StatelessWidget {
  const TransitScreen({Key? key}) : super(key: key);

  static const String id = "Transit_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transit Orders'),
      ),
      body: TransitOrderList(),
    );
  }
}

late String fromAddress = "No address";
Future<LatLng> getSellerAddress(BuildContext context, String email) async {
  final seller = await Provider.of<UserControllerProvider>(context, listen: false).getUser(email);
  fromAddress = seller!.address;
  return LatLng(seller!.latitude, seller.longitude);
}

class TransitOrderList extends StatefulWidget {
  @override
  State<TransitOrderList> createState() => _TransitOrderListState();
}

class _TransitOrderListState extends State<TransitOrderList> {
  @override
  void initState() {
    super.initState();

  }

  Future<void> getFromAddress(String email) async {
    final user = await Provider.of<UserControllerProvider>(context, listen: false).getUser(email);
    setState(() {
      fromAddress = user!.address;
    });
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Delivery').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error loading transit orders');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Image(image: AssetImage("assets/empty_data_icon.png")),
                ),
                Text("No Transit Orders found"),
              ],
            ),
          );
        }

        final transitOrders = snapshot.data!.docs;

        return ListView(
          children: transitOrders.map<Widget>((transitOrder) {
            final orderDetails = transitOrder['orderDetails'] as Map<String, dynamic>;
            final order = order_class.Order.fromJson(orderDetails);
            return FutureBuilder<LatLng>(
              future: getSellerAddress(context, order.sellerEmail),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading seller address');
                } else {
                  final latLng = snapshot.data!;
                  return Column(
                    children: [
                      ListTile(
                        title: Text('Order ID: ${order.orderId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Status:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${order.status}'),
                            const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('\$${order.totalAmount}'),
                            const Text('Order Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('${order.orderDate}'),
                            const Text('From:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Seller Address: ${fromAddress}'),
                            const Text('To:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(order.customer?.address ?? 'No customer address found'),
                            ElevatedButton(
                              onPressed: () {
                                _showDeliveredConfirmationDialog(context, order);
                              },
                              child: Text('Delivered'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: GoogleMap(
                          compassEnabled: false,
                          myLocationButtonEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(order.customer!.latitude, order.customer!.longitude),
                            zoom: 12,
                          ),
                          markers: _buildMarkers(order, latLng),
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _showDeliveredConfirmationDialog(BuildContext context, order_class.Order order) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delivery'),
          content: Text('Have you successfully delivered Order ID: ${order.orderId}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _markAsDelivered(context, order);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _markAsDelivered(BuildContext context, order_class.Order order) async {
    Provider.of<OrderControllerProvider>(context, listen: false).updateOrderStatus(order,"Delivered");
    await _removeFromDelivery(order.orderId);
  }

  Future<void> _removeFromDelivery(String orderId) async {
    final deliveryCollection = FirebaseFirestore.instance.collection('Delivery');
    final querySnapshot = await deliveryCollection.where('orderId', isEqualTo: orderId).get();

    // Delete the document if found
    if (querySnapshot.docs.isNotEmpty) {
      final documentId = querySnapshot.docs.first.id;
      await deliveryCollection.doc(documentId).delete();
    }
  }

  Set<Marker> _buildMarkers(order_class.Order order, LatLng latLng){
    Set<Marker> markers = Set();

    // Add source marker (seller's location)
    markers.add(
      Marker(
        markerId: MarkerId('source'),
        position: latLng,
        infoWindow: InfoWindow(
          title: 'Source',
        ),
      ),
    );

    // Add destination marker (customer's location)
    markers.add(
      Marker(
        markerId: MarkerId('destination'),
        position: LatLng(order.customer!.latitude, order.customer!.longitude),
        infoWindow: InfoWindow(
          title: 'Destination',
        ),
      ),
    );

    return markers;
  }
}
