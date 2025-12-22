import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/suboxd_footer_dark.dart';
import '../providers/auth_provider.dart';
import '../services/follow_service.dart';
import '../services/user_service.dart';

class FollowersScreen extends StatelessWidget {
  static const routeName = '/followers';

  const FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF1E2229);
    const dividerColor = Color(0xFF303542);

    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.user?.uid;
    final followService = FollowService();
    final userService = UserService();

    if (userId == null) {
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
        body: const Center(
          child: Text(
            'Please log in to view followers',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

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
              child: StreamBuilder<List<String>>(
                stream: followService.getFollowers(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final followerIds = snapshot.data ?? [];
                  if (followerIds.isEmpty) {
                    return const Center(
                      child: Text(
                        'No followers yet',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: followerIds.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: dividerColor, height: 1),
                    itemBuilder: (context, index) {
                      final followerId = followerIds[index];
                      return FutureBuilder<Map<String, dynamic>?>(
                        future: userService.getUserById(followerId),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(
                              leading: CircularProgressIndicator(),
                            );
                          }

                          final userData = userSnapshot.data;
                          final username = userData?['username'] as String? ??
                              userData?['email'] as String? ??
                              'Unknown';
                          final email = userData?['email'] as String? ?? '';

                          return ListTile(
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey.shade700,
                              child: Icon(Icons.person,
                                  size: 16, color: Colors.grey.shade300),
                            ),
                            title: Text(
                              username,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: email.isNotEmpty
                                ? Text(
                                    email,
                                    style: TextStyle(color: Colors.grey.shade400),
                                  )
                                : null,
                          );
                        },
                      );
                    },
                  );
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
