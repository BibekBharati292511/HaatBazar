import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hatbazarsample/AddToCart/add_to_cart_page.dart';
import 'package:hatbazarsample/Notification/notification_service.dart';
import 'package:hatbazarsample/OrderTracking/store_order_tracking.dart';
import 'package:hatbazarsample/ProductListPage/ProductListCat.dart';
import 'package:hatbazarsample/SellerCenter/order_request/order_request.dart';
import 'package:hatbazarsample/Utilities/ResponsiveDim.dart';
import 'package:hatbazarsample/Utilities/colors.dart';
import 'package:hatbazarsample/Utilities/constant.dart';
import 'package:hatbazarsample/Widgets/custom_button.dart';
import 'package:intl/intl.dart';
import '../AgroTechnicians/revenue_model.dart';
import '../Model/UserData.dart';
import '../MyOrdersAndHistory/order_and_history_main.dart';
import '../Recommendation/recommendation_service.dart';
import '../Review/review_dialouge.dart';
import '../Review/review_service.dart';
import '../SellerCenter/order_request/order_services_seller.dart';
import '../SellerCenter/order_request/request_completion_button.dart';
import '../main.dart';
import '../payment/payment_buyers.dart';
import 'Order.dart';

class OrderTrackingPage extends StatefulWidget {
  final OrderTracking order;

  const OrderTrackingPage({required this.order, Key? key}) : super(key: key);

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  var  sellerDataJson;
  late String sellerEmail;
  var sellerName;
  //ylate List<dynamic> storeData;
  final dateFormat = DateFormat('yyyy-MM-dd');
  bool isFetchByNameCompleted = false;
  bool _isLoading = true;
  List<OrderTracking> _orders = [];
  RecommenderService recommend=new RecommenderService();
  final NotificationService notificationService = NotificationService();
  final ReviewService services =new ReviewService();

  // Initialize storeData as an empty list initially
  late List<dynamic> storeData = [];

  @override
  void initState() {
    super.initState();
    fetchStoreDetail(widget.order.orderItems[0].storeId);
  }

  void fetchStoreDetail(int storeId) async {
    var storeDataJson = await UserDataService.fetchStoreDataById(storeId);
    setState(() {
      storeData = jsonDecode(storeDataJson);
      fetchSellerData(storeData[0]["token"]);
    });
  }

  void fetchSellerData(String token) async {
    var userData = await UserDataService.fetchUserData(token);
    setState(() {
      sellerDataJson = jsonDecode(userData);
      print(sellerDataJson);
      sellerEmail = "${sellerDataJson["email"]}";
      print(sellerEmail);
      sellerName = "${sellerDataJson["firstName"]} ${sellerDataJson["lastName"]}" ?? "";
      _isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;

    if (_isLoading || storeData.isEmpty || sellerEmail.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Order Tracking", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Once storeData and sellerEmail are fetched, continue building the UI
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Tracking", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Customer Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                // Other UI elements...
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Order tracking has started successfully",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Order ID: ${order.orderId}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Customer: ${order.customerName}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Contact: ${order.customerContact}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Email: ${order.customerEmail}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Seller Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Seller: $sellerName",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Store: ${storeData[0]["name"]}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Contact: ${storeData[0]["phone_number"]}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Email: $sellerEmail",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text(
                  "Order Items",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: order.orderItems.length,
                        itemBuilder: (context, index) {
                          final item = order.orderItems[index];
                          return Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ListTile(
                              title: Text(
                                "${item.productName} x${item.quantity}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text("Rs. ${item.price}"),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                const Divider(),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Delivery Method: ${order.deliveryMethod}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Payment Method: ${order.paymentMethod}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        Text(
                          "Order Status: ${order.orderStatus}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Estimated Delivery: ${dateFormat.format(order.estimatedDelivery)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildCustomButton(context, order.orderItems, sellerEmail, sellerDataJson["firstName"], sellerDataJson["lastName"], storeData[0]["token"]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context,List<OrderItem> orderItem,String email,String firstName,String lastName,String sellerToken) {
    final order = widget.order; // Access the passed order from widget
    return (role == "Buyers")
        ?order.orderStatus == "Completion_Requested"?
    CustomButton(
      buttonText: "Complete Now",
      color: Colors.red,

      onPressed: () async {
        print(email);
        if(order.paymentMethod=="Cash on Delivery (COD)"){
          await orderTracker(
              order.orderId, "Order Completed on date ${DateTime.now()}");
          await updateOrderTracking(order.orderId, "Completed");
          double totalPrice=0;
          for(var orders in orderItem){
            totalPrice+=orders.price*orders.quantity;
            await service.addRevenue(Revenue(
              amount: orders.price *orders.quantity,
              token: orders.productName,
              createdDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
            ));
          }
          print("harey ramaa");
          print(totalPrice);
          Revenue revenue = Revenue(
            amount: totalPrice,
            token: sellerToken,
            createdDate: DateTime(currentDate.year, currentDate.month, currentDate.day),
          );
          await service.addRevenue(revenue);
          print("yeha adkiyo ni ta sathi");

          notificationService.createNotification(
            email,
            "Order Transaction Completed successfully",
            "",
            "",
            false,
          );
          if(context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment Successful"),
                  backgroundColor: Colors.green),
            );
          }

          showRatingDialog(context, order.orderItems,sellerName);
        }
        else{
          khaltiPaymentBuyers(email, firstName, lastName, context, sellerToken,order.orderId,order,orderItem,sellerName);
        }
      },
      width: ResponsiveDim.screenWidth,
    ):   CustomButton(
      buttonText: "Shop more",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductListCat()),
        );
      },
      width: ResponsiveDim.screenWidth,
    )
        : (order.orderStatus == "Processing")
        ? CustomButton(
      buttonText: "Approve",
      onPressed: () {
        showApprovalDialog(context, false);
      },
      width: ResponsiveDim.screenWidth,
    )
        :(order.orderStatus=="Approved")?
    CustomButton(
      buttonText: "Start Shipping",
      onPressed: () {
        showApprovalDialog(context, true);
      },
      color: Colors.red,
      width: ResponsiveDim.screenWidth,
    ):(order.orderStatus=="Shipping") ||(order.orderStatus=="Completion_Requested")?
    RequestCompletionButton(
      orderId: order.orderId,
      buyerId: order.customerEmail,
      notificationService: notificationService,
    ) :const Column(
      children: [
        SizedBox(height: 20,),
        Text("This order has completed",style: TextStyle(fontSize: 18),),
        SizedBox(height: 20,),
      ],
    );
  }

  void showApprovalDialog(BuildContext context, bool isAlreadyApproved) {
    if (isAlreadyApproved) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Shipping Request"),
            content: const Text("This order is already approved. Start shipping now?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  showShipmentStartedDialog(context);
                },
                child: const Text("Start Shipping"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Order Approved"),
            content: const Text("Order has been approved, shipment starting."),
            actions: [
              TextButton(
                onPressed: () async {
                  await orderTracker(
                    widget.order.orderId,
                    "Order approved at date ${DateTime.now()}",
                  );
                  updateOrderTracking(widget.order.orderId,"Approved");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> orderRequest()));
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  void showShipmentStartedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Shipment Started"),
          content: const Text("Shipment has started successfully."),
          actions: [
            CustomButton(
              onPressed: () {
                orderTracker(
                  widget.order.orderId,
                  "Shipment started on date ${DateTime.now()}",
                );
                updateOrderTracking(widget.order.orderId,"Shipping");
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=> orderRequest()));
              },
              buttonText: "Ok",
            ),
          ],
        );
      },
    );
  }
  void showRatingDialog(BuildContext context, List<OrderItem> orderItems, String sellerName) {
    int sellerRating = 0;
    String sellerComment = '';
    List<int> productRatings = List.filled(orderItems.length, 0);
    List<String> productComments = List.filled(orderItems.length, '');

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text("Rate Seller and Products"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 8),
                      Text("Seller: $sellerName",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("Rate Seller:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      RatingBar(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemSize: 30.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          // Update seller rating
                          setState(() {
                            sellerRating = rating.toInt();
                          });
                        },
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.star, color: Colors.amber),
                          half: Icon(Icons.star_half, color: Colors.amber),
                          empty: Icon(Icons.star_border, color: Colors.amber),
                        ),
                      ),
                      // Seller comment text field
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'Seller Comment'),
                        onChanged: (value) {
                          // Update seller comment
                          setState(() {
                            sellerComment = value;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      Text("Rate Products:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Column(
                        children: List.generate(orderItems.length, (index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Text(orderItems[index].productName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              RatingBar(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemSize: 30.0,
                                itemPadding: EdgeInsets.symmetric(
                                    horizontal: 4.0),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    productRatings[index] = rating.toInt();
                                  });
                                },
                                ratingWidget: RatingWidget(
                                  full: Icon(Icons.star, color: Colors.amber),
                                  half: Icon(
                                      Icons.star_half, color: Colors.amber),
                                  empty: Icon(
                                      Icons.star_border, color: Colors.amber),
                                ),
                              ),
                              // Product comment text field
                              TextField(
                                decoration: InputDecoration(
                                    labelText: 'Product Comment'),
                                onChanged: (value) {
                                  setState(() {
                                    productComments[index] = value;
                                  });
                                },
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      print("Seller ratings");
                      print(sellerRating);
                      print(sellerComment);
                      await services.addReview(context: context,
                          rating: sellerRating,
                          comment: sellerComment,
                          ratingFrom: name,
                          ratingTo: sellerName);

                      for (int i = 0; i < orderItems.length; i++) {
                        String productName = orderItems[i].productName;
                        int rating = productRatings[i];
                        String comment = productComments[i];

                        print("Individual ratings");
                        print(productName);
                        print(rating);
                        print(comment);
                        await services.addReview(context: context,
                            rating: rating,
                            comment: comment,
                            ratingFrom: name,
                            ratingTo: productName);
                        if (productNameToId.containsKey(productName)) {
                          int productId = productNameToId[productName]!;
                          await recommend.addData(userDataJson["id"], productId, rating);
                        }
                      }
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const OrderAndHistoryMainPage()));
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text("Review added"),
                            backgroundColor: Colors.green),
                      );

                    },
                    child: Text('Submit'),
                  ),
                ],
              );
            },
          );
        });
  }

    }
