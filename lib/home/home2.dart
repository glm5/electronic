import 'package:flutter/material.dart';

class Home2 extends StatelessWidget {
  const Home2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 41, 50, 67),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 32, 39, 50),
        elevation: 0,
        title: const Text(
          "Electronic",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: Icon(Icons.menu, color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.search, color: Colors.white),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //----------------------------------------------------
            // ==========  CATEGORIES BAR (HORIZONTAL) ==========
            //----------------------------------------------------
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  categoryChip("Electronic Components", true),
                  categoryChip("Computer Parts", false),
                  categoryChip("Boards & Systems", false),
                  categoryChip("Sensors", false),
                ],
              ),
            ),

            const SizedBox(height: 15),

            //----------------------------------------------------
            // ==========  PRODUCTS LIST (VERTICAL)  ==============
            //----------------------------------------------------
            Expanded(
              child: ListView(
                children: [
                  productCard(
                    img: "https://i.imgur.com/TSdZQdd.png",
                    title: "DIODE",
                    desc:
                        "A diode is an electronic component that passes electric current in only one direction and blocks it in the opposite direction..",
                  ),

                  productCard(
                    img: "https://i.imgur.com/Z8i8H9G.png",
                    title: "POTENTIOMETER",
                    desc:
                        "An electronic component that allows the resistance value to be manually changed by rotating a shaft.",
                  ),

                  productCard(
                    img: "https://i.imgur.com/TSdZQdd.png",
                    title: "DIODE",
                    desc:
                        "Allows current to flow in only one direction and blocks it in the opposite direction.",
                  ),

                  productCard(
                    img: "https://i.imgur.com/rRktYUk.png",
                    title: "CAPACITOR",
                    desc:
                        "An electronic component that stores electrical energy in an electric field.",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //-----------------------------------------------------------
  // ========== CATEGORY CHIP WIDGET ==========================
  //-----------------------------------------------------------
  Widget categoryChip(String text, bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.lightBlueAccent : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  //-----------------------------------------------------------
  // ========== PRODUCT CARD WIDGET ===========================
  //-----------------------------------------------------------
  Widget productCard({
    required String img,
    required String title,
    required String desc,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF183642),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // image
          Container(
            width: 110,
            height: 110,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(img),
                fit: BoxFit.contain,
              ),
            ),
          ),

          // text section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    desc,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    "4 days ago",
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
