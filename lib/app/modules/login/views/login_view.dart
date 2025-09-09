import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Form(
        key: controller.formState,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animasi Lottie (bisa diganti file JSON lokal atau link)
              SizedBox(
                height: 180,
                child: Lottie.asset('assets/lottie/login.json'),
              ),

              const SizedBox(height: 20),

              FadeTransition(
                opacity: controller.fadeTransition,
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Login to continue",
                style: TextStyle(color: Colors.grey.shade600),
              ),

              const SizedBox(height: 40),

              // Email Field
              TextFormField(
                controller: controller.usernameController,

                validator: (value) => (value?.isEmpty ?? true)
                    ? 'Username tidak boleh kosong'
                    : null,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              Obx(
                () => TextFormField(
                  obscureText: controller.obscurePassword,
                  controller: controller.passwordController,
                  validator: (value) => (value?.isEmpty ?? true)
                      ? 'Password tidak boleh kosong'
                      : null,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        controller.obscurePassword =
                            !controller.obscurePassword;
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Tombol Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.login();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
