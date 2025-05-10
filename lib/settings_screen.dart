import 'package:flutter/material.dart';
import 'register_player_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Avatar + nút đổi avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundColor: Colors.deepOrange[100],
                    child: const Text(
                      "🍄",
                      style: TextStyle(fontSize: 54),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.add_a_photo, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Thông tin
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Thông tin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54)),
                    const SizedBox(height: 16),
                    _InfoRow(icon: Icons.account_balance_wallet, label: "Số dư trong ví", value: "0đ"),
                    const SizedBox(height: 8),
                    _InfoRow(icon: Icons.balance, label: "Biến động số dư"),
                    const SizedBox(height: 8),
                    _InfoRow(icon: Icons.info, label: "ID: son0570", value: "https://playerduo.net/67c6ab9901e43d2c4bdc4c60", isLink: true),
                    const SizedBox(height: 8),
                    _InfoRow(icon: Icons.share, label: "Chia sẻ link"),
                    const SizedBox(height: 24),
                    const Text("Cài đặt", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54)),
                    const SizedBox(height: 16),
                    _SettingSwitch(icon: Icons.message, label: "Nhận tin nhắn từ người lạ", value: true),
                    const SizedBox(height: 8),
                    _SettingSwitch(icon: Icons.notifications, label: "Nhận yêu cầu thuê Duo", value: false),
                    const SizedBox(height: 8),
                    _SettingRow(icon: Icons.settings, label: "Cài đặt avatar, tên, url, giá thuê"),
                    const SizedBox(height: 8),
                    _SettingRow(icon: Icons.lock, label: "Khóa bảo vệ", color: Colors.purple),
                    const SizedBox(height: 8),
                    _SettingRow(icon: Icons.policy, label: "Chính sách", color: Colors.red),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {},
                        child: const Text("Đăng xuất", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: Icon(Icons.person_add, color: Colors.deepOrange),
                      title: Text('Đăng ký làm Player'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPlayerScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isLink;
  const _InfoRow({
    required this.icon,
    required this.label,
    this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.deepOrange[100],
          child: Icon(icon, color: Colors.deepOrange, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              if (value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    value!,
                    style: TextStyle(
                      fontSize: 15,
                      color: isLink ? Colors.deepOrange : Colors.black87,
                      decoration: isLink ? TextDecoration.underline : null,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final Color? color;
  const _SettingSwitch({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: (color is MaterialColor)
              ? (color as MaterialColor).shade100
              : (color ?? Colors.blue).withOpacity(0.15),
          child: Icon(icon, color: color ?? Colors.blue, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        Switch(
          value: value,
          onChanged: (v) {},
          activeColor: Colors.deepOrange,
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _SettingRow({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: (color is MaterialColor)
              ? (color as MaterialColor).shade100
              : (color ?? Colors.yellow).withOpacity(0.15),
          child: Icon(icon, color: color ?? Colors.yellow[800], size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
} 