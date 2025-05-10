import 'package:flutter/material.dart';
import 'api_service.dart';

class RegisterPlayerScreen extends StatefulWidget {
  const RegisterPlayerScreen({super.key});

  @override
  State<RegisterPlayerScreen> createState() => _RegisterPlayerScreenState();
}

class _RegisterPlayerScreenState extends State<RegisterPlayerScreen> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final gameNameController = TextEditingController();
  final rankController = TextEditingController();
  final roleController = TextEditingController();
  final serverController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final statusController = TextEditingController(text: "AVAILABLE");

  bool isLoading = false;

  Future<void> handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);

    final data = {
      "username": usernameController.text.trim(),
      "gameName": gameNameController.text.trim(),
      "rank": rankController.text.trim(),
      "role": roleController.text.trim(),
      "server": serverController.text.trim(),
      "pricePerHour": double.tryParse(priceController.text.trim()) ?? 0,
      "description": descriptionController.text.trim(),
      "status": statusController.text.trim(),
    };

    final error = await ApiService.registerPlayer(data);
    setState(() => isLoading = false);

    if (error == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký player thành công!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký làm Player'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Tên tài khoản'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: gameNameController,
                decoration: const InputDecoration(labelText: 'Tên game'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: rankController,
                decoration: const InputDecoration(labelText: 'Rank'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: serverController,
                decoration: const InputDecoration(labelText: 'Server'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Giá/giờ (VNĐ)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Mô tả'),
                maxLength: 500,
              ),
              TextFormField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Trạng thái'),
                validator: (v) => v!.isEmpty ? 'Không được để trống' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Đăng ký', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 