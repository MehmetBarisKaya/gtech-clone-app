import 'package:flutter/material.dart';
import 'package:gtech/widgets/formtextfield.dart';

class ProfileDetails extends StatefulWidget {
  final String name;
  final String email;
  final String phoneNumber;
  final bool? isVisible;
  const ProfileDetails({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.isVisible,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormTextField(
              labelText: widget.name, icon: const Icon(Icons.info_outline)),
          const SizedBox(
            height: 10,
          ),
          FormTextField(
              labelText: widget.email, icon: const Icon(Icons.info_outline)),
          const SizedBox(
            height: 10,
          ),
          FormTextField(
              labelText: widget.phoneNumber,
              icon: const Icon(Icons.info_outline)),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
