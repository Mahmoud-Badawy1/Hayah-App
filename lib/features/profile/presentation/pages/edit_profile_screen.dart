import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/animations/app_animations.dart';
import '../../../../core/design/atoms/atoms.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _formAnimation;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'John');
  final _lastNameController = TextEditingController(text: 'Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1 234 567 890');
  final _addressController = TextEditingController(
    text: '123 Main St, New York, NY 10001',
  );
  DateTime _dateOfBirth = DateTime(1990, 1, 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.defaultDuration,
    );

    _formAnimation = CurvedAnimation(
      parent: _controller,
      curve: AppAnimations.smoothCurve,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        UpdateProfileRequested(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          dateOfBirth: _dateOfBirth,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(onPressed: _saveProfile, child: const Text('Save')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: FadeTransition(
            opacity: _formAnimation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(_formAnimation),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: theme.primaryColor.withAlpha(25),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: theme.primaryColor,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppTextInput(
                    label: 'First Name',
                    controller: _firstNameController,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your first name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextInput(
                    label: 'Last Name',
                    controller: _lastNameController,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your last name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  AppTextInput(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      }
                      if (!value!.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextInput(
                    label: 'Phone',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your phone number'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: AppTextInput(
                        label: 'Date of Birth',
                        controller: TextEditingController(
                          text:
                              '${_dateOfBirth.month}/${_dateOfBirth.day}/${_dateOfBirth.year}',
                        ),
                        suffixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppTextInput(
                    label: 'Address',
                    controller: _addressController,
                    maxLines: 2,
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your address'
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
