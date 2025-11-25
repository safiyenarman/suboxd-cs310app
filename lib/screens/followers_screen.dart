import 'package:flutter/material.dart';
import '../widgets/suboxd_footer_dark.dart';

class FollowersScreen extends StatelessWidget {
  static const routeName = '/followers';

  const FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1E2229);
    const dividerColor = Color(0xFF303542);

    final followers =
    List<String>.generate(9, (i) => 'username${i + 1}');

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFF15181E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Followers'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: followers.length + 2,
                separatorBuilder: (_, __) =>
                const Divider(color: dividerColor, height: 1),
                itemBuilder: (context, index) {
                  if (index < followers.length) {
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.grey.shade700,
                        child: Icon(Icons.person,
                            size: 16, color: Colors.grey.shade300),
                      ),
                      title: Text(
                        followers[index],
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '. . .',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            const SuboxdFooterDark(),
          ],
        ),
      ),
    );
  }
}
