import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:indian_farmer/Model/Details_Page_model.dart';
import 'package:indian_farmer/Res/Const_Color.dart';
import 'package:indian_farmer/Res/Const_Text_Style.dart';
import 'package:indian_farmer/View/Kisaan_Info_Page.dart';
import 'package:indian_farmer/Res/App_Bar_Style.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int itemCount = 0;
  var showAll = true;
  final length = 150;

  List<DetailsPage> DetailsItems = [
    DetailsPage(
      Image:
          'https://rukminim2.flixcart.com/image/850/1000/xif0q/plant-seed/e/5/s/600-dhan-paddy-seeds-bdsresolve-original-imagxay6sb8ygkde.jpeg?q=20&crop=false',
      name: 'Premium Paddy Seeds',
      description: "High-yield hybrid variety",
      subDescription:
          '''For effective paddy seed treatment, consider wet seed treatment with fungicides like Carbendazim or Pyroquilon, and biological inoculants like Bacillus subtilis or Azospirillum. This approach offers protection against seedling diseases and enhances nutrient uptake. These seeds are specially treated to ensure maximum germination rate and disease resistance.''',
      stock: "Available In Stock",
      rating: "4.5",
      offer: "42% OFF",
      price: 29.99,
      subPrice: 22.3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    // Responsive padding calculations
    final horizontalPadding = screenWidth * 0.04;
    final verticalPadding = screenHeight * 0.02;
    final productImageHeight =
        isPortrait ? screenHeight * 0.3 : screenHeight * 0.5;
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppBarStyle.flexibleSpace(),
        title: Text(
          "Product Details",
          style: ConstTextStyle.appbarTitle.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Share/Favorite Buttons
            SizedBox(
              height: productImageHeight,
              width: double.infinity,
              child: Stack(
                children: [
                  // Main Product Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: DetailsItems[0].Image,
                      placeholder:
                          (context, url) => Center(
                            child: CircularProgressIndicator(
                              color: ConstColor.primaryColorGreen,
                            ),
                          ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: screenHeight * 0.02,
                    right: screenWidth * 0.03,
                    child: Row(
                      children: [
                        _buildIconButton(
                          icon: Icons.share,
                          onTap: () {},
                          size: screenWidth * 0.06,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        _buildIconButton(
                          icon: Icons.favorite_border,
                          onTap: () {},
                          size: screenWidth * 0.06,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Product Details Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          DetailsItems[0].name,
                          style: ConstTextStyle.ProductTitle1.copyWith(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: screenWidth * 0.04,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              DetailsItems[0].rating,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.015),

                  // Price and Offer
                  Row(
                    children: [
                      Text(
                        "₹${DetailsItems[0].subPrice}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: ConstColor.primaryColorGreen,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        "₹${DetailsItems[0].price}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          DetailsItems[0].offer,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  // Description with Read More
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        DetailsItems[0].description,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  DetailsItems[0].subDescription.length >
                                              length &&
                                          !showAll
                                      ? "${DetailsItems[0].subDescription.substring(0, length)}..."
                                      : DetailsItems[0].subDescription,
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: Colors.black54,
                                height: 1.5,
                              ),
                            ),
                            if (DetailsItems[0].subDescription.length > length)
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      showAll = !showAll;
                                    });
                                  },
                                  child: Text(
                                    showAll ? ' Read Less' : ' Read More',
                                    style: TextStyle(
                                      color: ConstColor.primaryColorGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                    height: screenHeight * 0.04,
                  ),
                ],
              ),
            ),

            // Information Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Information",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  SizedBox(
                    height: screenHeight * 0.15,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.03),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => KisaanInfoPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: screenWidth * 0.18,
                                  height: screenWidth * 0.18,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(
                                      color: ConstColor.primaryColorGreen,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withValues(
                                          alpha: 0.2,
                                        ),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEIQ4GWpI1UIFYiAkryHn43lPgKeoACgpjSg&s',
                                      placeholder:
                                          (
                                            context,
                                            url,
                                          ) => CircularProgressIndicator(
                                            color: ConstColor.primaryColorGreen,
                                          ),
                                      errorWidget:
                                          (context, url, error) =>
                                              Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                [
                                  "Sichai",
                                  "Beej",
                                  "Khad",
                                  "Devi",
                                  "Rog",
                                ][index],
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Similar Products Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Similar Products",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    separatorBuilder:
                        (context, index) =>
                            Divider(thickness: 1, height: screenHeight * 0.03),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsScreen(),
                              ),
                            ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: SizedBox(
                                  width: screenWidth * 0.25,
                                  height: screenWidth * 0.25,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://img.freepik.com/premium-vector/indian-farmer-holding-green-crops_1308360-47.jpg',
                                      placeholder:
                                          (context, url) =>
                                              CircularProgressIndicator(),
                                      errorWidget:
                                          (context, url, error) =>
                                              Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      [
                                        "Organic Fertilizer",
                                        "Hybrid Seeds",
                                        "Pesticides",
                                      ][index],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.038,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      "₹${[199, 299, 399][index]}",
                                      style: TextStyle(
                                        color: ConstColor.primaryColorGreen,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.04,
                                      ),
                                    ),
                                    Text(
                                      "₹${[299, 399, 499][index]}",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02,
                                            vertical: screenHeight * 0.005,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            "${[42, 25, 30][index]}% OFF",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.03,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.02,
                                            vertical: screenHeight * 0.005,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: screenWidth * 0.035,
                                              ),
                                              SizedBox(
                                                width: screenWidth * 0.01,
                                              ),
                                              Text(
                                                "${[4.5, 4.2, 4.0][index]}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: screenWidth * 0.03,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsScreen(),
                                      ),
                                    ),
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: screenWidth * 0.04,
                                  color: ConstColor.textColorBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.1), // Bottom padding for buttons
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size * 0.3),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }
}
