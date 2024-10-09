import 'package:flutter/material.dart';
import '../pages/transporteur_card.dart';
import '../pages/available_gp_card.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String _selectedTab = "Annonces";

  final List<String> transporteurs = ["Transporteur 1", "Transporteur 2", "Transporteur 3"];
  final List<String> annonces = ["Annonce 1", "Annonce 2", "Annonce 3"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery App',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 16),

          Divider(
            color: Colors.white,
            thickness: 1,
          ),

          SizedBox(height: 16),

          // Search Bar inside the body
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search here',
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[200],
                filled: true,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          SizedBox(height: 16),

          Divider(
            color: Colors.white,
            thickness: 1,
          ),

          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/images.png'),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/images.png'),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/images.png'),
                ),
                SizedBox(width: 8),
                Icon(Icons.add),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(child: TransporteurCard(name: "Transporteur123")),
                SizedBox(width: 16),
                Expanded(child: TransporteurCard(name: "Transporteur543")),
              ],
            ),
          ),

          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = "Annonces";
                    });
                  },
                  child: Text(
                    'Annonces',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _selectedTab == "Annonces" ? FontWeight.normal : FontWeight.normal,
                      color: _selectedTab == "Annonces" ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = "Transporteurs";
                    });
                  },
                  child: Text(
                    'Transporteurs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: _selectedTab == "Transporteurs" ? FontWeight.bold : FontWeight.normal,
                      color: _selectedTab == "Transporteurs" ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          Divider(
            color: Colors.white,
            thickness: 1,
          ),

          Column(
            children: List.generate(
              _selectedTab == "Annonces" ? annonces.length : transporteurs.length,
                  (index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: _selectedTab == "Annonces"
                          ? AvailableGPCard()
                          : TransporteurCard(name: transporteurs[index]),
                    ),
                    Divider(
                      color: Colors.grey[200],
                      thickness: 1,
                      height: 10,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
