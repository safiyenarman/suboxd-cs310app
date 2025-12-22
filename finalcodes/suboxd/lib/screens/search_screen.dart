import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suboxd/screens/add_review_screen.dart';
import '../routes.dart';
import 'profile_screen.dart';
import '../providers/courses_provider.dart';
import '../providers/auth_provider.dart';
import '../models/course_model.dart';
import '../services/user_service.dart';
import '../services/follow_service.dart';

const Color bg = Color(0xFF1E2229);
const Color cardColor = Color(0xFF262B33);
const Color primaryColor = Color(0xFF4B8BF4);
const Color dividerColor = Color(0xFF303542);
const Color appBarColor = Color(0xFF15181E);
const Color bottomBarColor = Color(0xFF485365);
const Color tabSelected = Color(0xFF4B8BF4);
const Color tabUnselected = Color(0xFF343A45);

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  final UserService _userService = UserService();
  final FollowService _followService = FollowService();

  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavBar = BottomNavigationBar(
      backgroundColor: bottomBarColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: 1,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      items: const [

        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),

        BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),

        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, color: Colors.greenAccent),
          label: '',
        ),

        BottomNavigationBarItem(icon: Icon(Icons.flash_on_outlined), label: ''),

        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
      onTap: (index) {

        switch (index) {
          case 0:

            Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
            break;
          case 1:

            break;
          case 2:
            Navigator.pushNamed(context, AddReviewScreen.routeName);
            break;
          case 3:

            Navigator.pushNamedAndRemoveUntil(context, Routes.friendsActivity, (route) => false);
            break;
          case 4:

            Navigator.pushNamedAndRemoveUntil(context, ProfileScreen.routeName, (route) => false);
            break;
          default:

            break;
        }
      },
    );

    return Scaffold(
      backgroundColor: bg,
      bottomNavigationBar: bottomNavBar,
      body: SafeArea(
        child: Column(
          children: [

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: appBarColor,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(color: Colors.white54, fontSize: 18),
                          prefixIcon: Icon(Icons.search, color: Colors.white54),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();

                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.home, (route) => false);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: dividerColor),

            Container(
              color: appBarColor,
              child: TabBar(
                controller: _tabController,
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Courses'),
                  Tab(text: 'Users'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCoursesTab(),
                  _buildUsersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    final coursesProvider = context.watch<CoursesProvider>();
    final query = _searchController.text.toLowerCase();
    final allCourses = coursesProvider.courses;

    final filteredCourses = query.isEmpty
        ? allCourses
        : allCourses.where((course) {
            final codeLower = course.name.toLowerCase();
            final nameLower = course.name.toLowerCase();
            final instructorLower = course.instructor.toLowerCase();
            return codeLower.contains(query) ||
                nameLower.contains(query) ||
                instructorLower.contains(query);
          }).toList();

    if (coursesProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredCourses.isEmpty) {
      return Center(
        child: Text(
          query.isEmpty ? 'No courses available' : 'No courses found',
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        return _CourseListTile(course: course);
      },
    );
  }

  Widget _buildUsersTab() {
    final query = _searchController.text.toLowerCase();
    final authProvider = context.watch<AuthProvider>();
    final currentUserId = authProvider.user?.uid;

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _userService.getAllUsers(),
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

        final allUsers = snapshot.data ?? [];

        final otherUsers = allUsers.where((user) => user['id'] != currentUserId).toList();

        final filteredUsers = query.isEmpty
            ? otherUsers
            : otherUsers.where((user) {
                final email = (user['email'] as String? ?? '').toLowerCase();
                final username = (user['username'] as String? ?? '').toLowerCase();
                return email.contains(query) || username.contains(query);
              }).toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: Text(
              query.isEmpty ? 'No users available' : 'No users found',
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return _UserListTile(
              userId: user['id'] as String,
              email: user['email'] as String? ?? '',
              username: user['username'] as String? ?? user['email'] as String? ?? '',
            );
          },
        );
      },
    );
  }
}

class _CourseListTile extends StatelessWidget {
  final CourseModel course;

  const _CourseListTile({required this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              width: 75,
              height: 110,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/${course.name.toLowerCase().replaceAll(' ', '')}.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.code, color: Colors.greenAccent, size: 30));
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: SizedBox(
                height: 110,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      course.instructor.isNotEmpty ? course.instructor : 'No instructor',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            Flexible(
              child: Text(
                course.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserListTile extends StatefulWidget {
  final String userId;
  final String email;
  final String username;

  const _UserListTile({
    required this.userId,
    required this.email,
    required this.username,
  });

  @override
  State<_UserListTile> createState() => _UserListTileState();
}

class _UserListTileState extends State<_UserListTile> {
  final FollowService _followService = FollowService();
  bool _isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFollowingStatus();
  }

  Future<void> _checkFollowingStatus() async {
    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.user?.uid;
    if (currentUserId == null) return;

    try {
      final isFollowing = await _followService.isFollowing(currentUserId, widget.userId);
      if (mounted) {
        setState(() {
          _isFollowing = isFollowing;
        });
      }
    } catch (e) {
      print('Error checking follow status: $e');
    }
  }

  Future<void> _toggleFollow() async {
    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.user?.uid;
    if (currentUserId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFollowing) {
        await _followService.removeFollow(currentUserId, widget.userId);
      } else {
        await _followService.addFollow(currentUserId, widget.userId);
      }
      if (mounted) {
        setState(() {
          _isFollowing = !_isFollowing;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Error toggling follow: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: cardColor,
              child: Icon(
                Icons.person,
                color: Colors.grey.shade300,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _toggleFollow,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFollowing ? Colors.grey.shade700 : primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _isFollowing ? 'Following' : 'Follow',
                      style: const TextStyle(fontSize: 14),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}