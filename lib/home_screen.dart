import 'package:flutter/material.dart';
import 'hire_player_screen.dart';
import 'player_detail_screen.dart';
import 'api_service.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> players = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    final data = await ApiService.fetchAllPlayers();
    setState(() {
      players = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        Icon(Icons.sports_esports, color: Colors.deepOrange, size: 36),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'PLAYERDUO',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 1),
                            ),
                            Text(
                              'GAME COMMUNITY',
                              style: TextStyle(fontSize: 12, color: Colors.black54, letterSpacing: 1),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.black54),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_alt_outlined, color: Colors.black54),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  // Kết nối
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Row(
                      children: const [
                        Icon(Icons.movie_filter, color: Colors.deepOrange, size: 22),
                        SizedBox(width: 8),
                        Text('Kết nối', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: const [
                        _GameIcon(title: 'PUBG Mobile', icon: Icons.sports_motorsports),
                        _GameIcon(title: 'PUBG PC', icon: Icons.sports_esports),
                        _GameIcon(title: 'Liên Quân Mobile', icon: Icons.sports_handball),
                      ],
                    ),
                  ),
                  // VIP Player
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Row(
                      children: const [
                        Icon(Icons.movie_filter, color: Colors.deepOrange, size: 22),
                        SizedBox(width: 8),
                        Text('VIP Player', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : players.isEmpty
                            ? const Center(child: Text('Chưa có player nào'))
                            : ListView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                children: players.map((player) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayerDetailScreen(player: player),
                                        ),
                                      );
                                    },
                                    child: _VipPlayerCard(
                                      name: player['username'] ?? '',
                                      price: '${player['pricePerHour'] ?? ''} đ / giờ',
                                      description: player['description'] ?? '',
                                      tags: '${player['gameName'] ?? ''},${player['rank'] ?? ''},${player['role'] ?? ''}',
                                      isOnline: player['status'] == 'AVAILABLE',
                                      isGray: false,
                                    ),
                                  );
                                }).toList(),
                              ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GameIcon extends StatelessWidget {
  final String title;
  final IconData icon;
  const _GameIcon({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              child: Icon(icon, size: 32, color: Colors.deepOrange),
              backgroundColor: Colors.white,
              radius: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _VipPlayerCard extends StatelessWidget {
  final String name;
  final String price;
  final String description;
  final String tags;
  final bool isOnline;
  final bool isGray;
  const _VipPlayerCard({
    required this.name,
    required this.price,
    required this.description,
    required this.tags,
    required this.isOnline,
    required this.isGray,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh đại diện (icon thay thế)
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isGray ? Colors.grey[300] : Colors.orange[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: Center(
              child: Icon(Icons.person, size: 48, color: isGray ? Colors.grey : Colors.deepOrange),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepOrange),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isOnline)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(Icons.circle, color: Colors.green, size: 12),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              description,
              style: const TextStyle(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: Text(
              tags,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                price,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}