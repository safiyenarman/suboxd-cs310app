import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _givenNameController = TextEditingController(text: 'name');
  final _familyNameController = TextEditingController(text: 'surname');
  final _emailController = TextEditingController(text: 'mailname@gmail.com');

  @override
  void dispose() {
    _givenNameController.dispose();
    _familyNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF485365);
    const cardColor = Color(0xFF556173);
    const sectionTitleColor = Color(0xFFAEB7C4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: cardColor,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, color: Color(0xFF647285)),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text.rich(
                            TextSpan(
                              text: 'Signed in as ',
                              style: TextStyle(
                                color: Color(0xFFD3D8E0),
                              ),
                              children: [
                                TextSpan(
                                  text: 'username',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Sign out',
                            style: TextStyle(
                              color: Colors.orangeAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'PROFILE',
                      style: TextStyle(
                        color: sectionTitleColor,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SettingsField(
                      label: 'Given name',
                      controller: _givenNameController,
                    ),
                    _SettingsField(
                      label: 'Family name',
                      controller: _familyNameController,
                    ),
                    _SettingsField(
                      label: 'Mail address',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'AVATAR',
                      style: TextStyle(
                        color: sectionTitleColor,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey.shade700,
                            child: Icon(
                              Icons.person,
                              size: 34,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'Add or update your profile photo directly from here. You can upload a new picture or change it anytime.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFD3D8E0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'FAVORITE COURSES',
                      style: TextStyle(
                        color: sectionTitleColor,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(4, (index) {
                        return Expanded(
                          child: Container(
                            height: 80,
                            margin:
                            EdgeInsets.only(right: index == 3 ? 0 : 8),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 26,
                                  color: Color(0xFFD3D8E0),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'TERMS OF USE',
                      style: TextStyle(
                        color: sectionTitleColor,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'By using SUboxd, you agree to share course feedback respectfully. '
                            'Personal attacks, offensive language, or harassment toward instructors or '
                            'students are not allowed. Constructive criticism about courses or teaching '
                            'methods is welcome. Violating content may be removed and accounts suspended.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD3D8E0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/su_boxd_logo.png',
                            height: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'SUboxd',
                            style: TextStyle(
                              color: Color(0xFFD3D8E0),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const _SettingsField({
    required this.label,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF647285);

    return Column(
      children: [
        const Divider(color: borderColor, height: 1),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Color(0xFFD3D8E0),
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding:
            EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          ),
        ),
      ],
    );
  }
}
