import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homenom/constants/constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const String id = "Cart_Screen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart List"),
        backgroundColor: kAppBackgroundColor,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.clear_all),
          onPressed: () {
            // clearCartNow(context);
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn1",
              label: const Text(
                "Clear Cart",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: kAppBackgroundColor,
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                // clearCartNow(context);
                //
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (c) => const SplashScreen()));
                //
                // Fluttertoast.showToast(msg: "Cart has been cleared.");
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: FloatingActionButton.extended(
              heroTag: "btn2",
              label: const Text(
                "Check Out",
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: kAppBackgroundColor,
              icon: const Icon(Icons.navigate_next),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (c) => AddressScreen(
                //       totalAmount: totalAmount.toDouble(),
                //       sellerUID: widget.sellerUID,
                //     ),
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
      body: Container(

        child: CustomScrollView(
          slivers: [
            //overall total price


            // SliverToBoxAdapter(
            //   child: Consumer2<TotalAmount, CartItemCounter>(
            //       builder: (context, amountProvider, cartProvider, c) {
            //         return Padding(
            //           padding: const EdgeInsets.all(8),
            //           child: Center(
            //             child: cartProvider.count == 0
            //                 ? Container()
            //                 : Text(
            //               "Total Price: ${"\$" + amountProvider.tAmount.toString()}",
            //               style: GoogleFonts.lato(
            //                 textStyle: const TextStyle(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.black87,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         );
            //       }),
            // ),

            //display cart items with quantity numbers
            // StreamBuilder<QuerySnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection("items")
            //       .where("itemID", whereIn: separateItemIDs())
            //       .orderBy("publishedDate", descending: true)
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     return !snapshot.hasData
            //         ? SliverToBoxAdapter(
            //       child: Center(
            //         child: circularProgress(),
            //       ),
            //     )
            //     //if length = 0 no data
            //     // : snapshot.data!.docs.length == 0
            //     //     ? Container()
            //         : SliverList(
            //       delegate: SliverChildBuilderDelegate(
            //             (context, index) {
            //           Items model = Items.fromJson(
            //             snapshot.data!.docs[index].data()!
            //             as Map<String, dynamic>,
            //           );
            //
            //           //calculating total price in cart list
            //           if (index == 0) {
            //             totalAmount = 0;
            //             totalAmount = totalAmount +
            //                 (model.price! *
            //                     separateItemQuantityList![index]);
            //           } else {
            //             totalAmount = totalAmount +
            //                 (model.price! *
            //                     separateItemQuantityList![index]);
            //           }
            //           //update in real time
            //           if (snapshot.data!.docs.length - 1 == index) {
            //             WidgetsBinding.instance.addPostFrameCallback(
            //                   (timeStamp) {
            //                 Provider.of<TotalAmount>(context,
            //                     listen: false)
            //                     .displayTotalAmount(
            //                     totalAmount.toDouble());
            //               },
            //             );
            //           }
            //
            //           return CartItemDesign(
            //             model: model,
            //             context: context,
            //             quanNumber: separateItemQuantityList![index],
            //           );
            //         },
            //         childCount:
            //         snapshot.hasData ? snapshot.data!.docs.length : 0,
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
