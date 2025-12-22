import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/courses_provider.dart';
import '../models/favorite_model.dart';
import '../models/course_model.dart';
import '../services/user_service.dart';
import '../routes.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserService _userService = UserService();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  String? _avatarUrl;
  bool _isUploading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<ImageProvider?> _getImageProvider(XFile imageFile) async {

    final bytes = await imageFile.readAsBytes();
    return MemoryImage(bytes);
  }

  Future<ImageProvider?> _getAvatarImageProvider(String? dataUrl) async {
    if (dataUrl == null || dataUrl.isEmpty) {
      return null;
    }

    try {

      if (dataUrl.startsWith('data:image')) {

        final base64String = dataUrl.split(',')[1];
        final bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      } else {

        return NetworkImage(dataUrl);
      }
    } catch (e) {
      print('Error decoding avatar: $e');
      return null;
    }
  }

  Future<void> _uploadAvatar(String userId) async {
    if (_selectedImage == null) {

      if (mounted) Navigator.pop(context);
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      await _userService.updateUserAvatar(userId, _selectedImage!);
      if (!mounted) return;
      setState(() {
        _avatarUrl = null;
        _selectedImage = null;
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Avatar updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
      });

      String errorMessage = 'Failed to upload avatar';
      if (e.toString().contains('too large')) {
        errorMessage = 'Image is too large. Please select a smaller image (max 800KB).';
      } else if (e.toString().contains('read')) {
        errorMessage = 'Failed to read image file. Please try selecting the image again.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _openFavoritePicker(
      BuildContext context, String userId, String? existingFavoriteId) async {
    final coursesProvider = context.read<CoursesProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();

    final allCourses = coursesProvider.courses;

    List<FavoriteCourse> existingFavorites = [];
    try {
      existingFavorites = await favoritesProvider
          .favoritesForUser(userId)
          .first;
    } catch (e) {
      print('Error loading favorites: $e');
    }

    final existingCourseCodes = existingFavorites
        .where((fav) => fav.id != existingFavoriteId)
        .map((fav) => fav.courseCode)
        .toSet();

    if (allCourses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No courses available. Please wait for courses to load.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF262B33),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                existingFavoriteId == null
                    ? 'Select a course to add'
                    : 'Select a course to replace',
                style: const TextStyle(
                  color: Color(0xFFD3D8E0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: allCourses.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Color(0xFF303542), height: 1),
                itemBuilder: (_, index) {
                  final course = allCourses[index];
                  final isAlreadyAdded = existingCourseCodes.contains(course.name);

                  return ListTile(
                    enabled: !isAlreadyAdded,
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade700,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/${course.name.toLowerCase().replaceAll(' ', '')}.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.menu_book,
                              color: Colors.grey.shade300,
                            );
                          },
                        ),
                      ),
                    ),
                    title: Text(
                      '${course.name}',
                      style: TextStyle(
                        color: isAlreadyAdded
                            ? Colors.grey.shade600
                            : const Color(0xFFD3D8E0),
                      ),
                    ),
                    subtitle: course.instructor.isNotEmpty
                        ? Text(
                            course.instructor,
                            style: TextStyle(
                              color: isAlreadyAdded
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade400,
                            ),
                          )
                        : null,
                    trailing: isAlreadyAdded
                        ? const Text(
                            'Already added',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          )
                        : null,
                    onTap: isAlreadyAdded
                        ? null
                        : () async {
                            try {
                              final imageAsset =
                                  'assets/${course.name.toLowerCase().replaceAll(' ', '')}.png';

                              if (existingFavoriteId != null) {

                                final favorite = FavoriteCourse(
                                  id: existingFavoriteId,
                                  userId: userId,
                                  courseCode: course.name,
                                  courseName: course.name,
                                  imageAsset: imageAsset,
                                  createdAt: DateTime.now(),
                                );
                                await favoritesProvider.updateFavorite(
                                    existingFavoriteId, favorite);
                                if (!mounted) return;
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Favorite course updated successfully!'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              } else {

                                final favorite = FavoriteCourse(
                                  id: '',
                                  userId: userId,
                                  courseCode: course.name,
                                  courseName: course.name,
                                  imageAsset: imageAsset,
                                  createdAt: DateTime.now(),
                                );
                                await favoritesProvider.addFavorite(favorite);
                                if (!mounted) return;
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Favorite course added successfully!'),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteFavoriteDialog(
      BuildContext context, String userId, FavoriteCourse favorite) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF262B33),
        title: const Text(
          'Delete Favorite?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to remove "${favorite.courseName}" from your favorites?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await context.read<FavoritesProvider>().deleteFavorite(favorite.id);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Favorite course removed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove favorite: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                    Builder(
                      builder: (context) {
                        final auth = context.watch<AuthProvider>();
                        final userId = auth.user?.uid;

                        return TextButton(
                          onPressed: _isUploading
                              ? null
                              : userId != null
                                  ? () async {
                                      await _uploadAvatar(userId);
                                    }
                                  : () => Navigator.pop(context),
                          child: _isUploading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.greenAccent),
                                  ),
                                )
                              : Text(
                                  _selectedImage != null ? 'Save' : 'Done',
                                  style: const TextStyle(
                                      color: Colors.greenAccent),
                                ),
                        );
                      },
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

                    Builder(
                      builder: (context) {
                        final auth = context.watch<AuthProvider>();
                        final email = auth.user?.email ?? 'guest';

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: 'Signed in as ',
                                  style: const TextStyle(
                                    color: Color(0xFFD3D8E0),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: email,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await context
                                        .read<AuthProvider>()
                                        .logout();
                                    if (!mounted) return;
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes.login,
                                      (_) => false,
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  'Sign out',
                                  style: TextStyle(
                                    color: Colors.orangeAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
                    Builder(
                      builder: (context) {
                        final auth = context.watch<AuthProvider>();
                        final email = auth.user?.email ?? '';
                        final username = email.split('@').first;

                        return Column(
                          children: [
                            _ProfileInfoField(
                              label: 'Username',
                              value: username,
                            ),
                            _ProfileInfoField(
                              label: 'Mail address',
                              value: email,
                            ),
                          ],
                        );
                      },
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
                    Builder(
                      builder: (context) {
                        final auth = context.watch<AuthProvider>();
                        final userId = auth.user?.uid;

                        if (userId == null) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Sign in to manage your avatar.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFD3D8E0),
                              ),
                            ),
                          );
                        }

                        return StreamBuilder<Map<String, dynamic>?>(
                          stream: _userService.userDataStream(userId),
                          builder: (context, snapshot) {
                            final avatarDataUrl = _selectedImage != null
                                ? null
                                : (snapshot.data?['avatarUrl'] as String?);

                            return GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        FutureBuilder<ImageProvider?>(
                                          future: _selectedImage != null
                                              ? _getImageProvider(_selectedImage!)
                                              : _getAvatarImageProvider(avatarDataUrl),
                                          builder: (context, snapshot) {
                                            return CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Colors.grey.shade700,
                                              backgroundImage: snapshot.data,
                                              child: _selectedImage == null &&
                                                      avatarDataUrl == null
                                                  ? Icon(
                                                      Icons.person,
                                                      size: 34,
                                                      color: Colors.grey.shade300,
                                                    )
                                                  : null,
                                            );
                                          },
                                        ),
                                        if (_selectedImage != null)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _selectedImage != null
                                                ? 'Tap to change photo'
                                                : 'Tap to upload photo',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Color(0xFFD3D8E0),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Add or update your profile photo directly from here. You can upload a new picture or change it anytime.',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
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
                    Builder(
                      builder: (context) {
                        final auth = context.watch<AuthProvider>();
                        final userId = auth.user?.uid;

                        if (userId == null) {
                          return const Text(
                            'Sign in to manage your favorite courses.',
                            style: TextStyle(
                              color: Color(0xFFD3D8E0),
                              fontSize: 13,
                            ),
                          );
                        }

                        return StreamBuilder<List<FavoriteCourse>>(
                          stream: context
                              .read<FavoritesProvider>()
                              .favoritesForUser(userId),
                          builder: (context, snapshot) {
                            final favorites = snapshot.data ?? [];
                            final displayed =
                                favorites.take(4).toList(growable: false);

                            return Row(
                              children: List.generate(4, (index) {
                                if (index < displayed.length) {

                                  final favorite = displayed[index];
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => _openFavoritePicker(
                                          context, userId, favorite.id),
                                      onLongPress: () => _showDeleteFavoriteDialog(
                                          context, userId, favorite),
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: 80,
                                            margin: EdgeInsets.only(
                                                right: index == 3 ? 0 : 8),
                                            decoration: BoxDecoration(
                                              color: cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    favorite.imageAsset),
                                                fit: BoxFit.cover,
                                                onError: (exception, stackTrace) {

                                                },
                                              ),
                                            ),
                                          ),

                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.edit,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {

                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => _openFavoritePicker(
                                          context, userId, null),
                                      child: Container(
                                        height: 80,
                                        margin: EdgeInsets.only(
                                            right: index == 3 ? 0 : 8),
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
                                    ),
                                  );
                                }
                              }),
                            );
                          },
                        );
                      },
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

class _ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoField({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFF647285);

    return Column(
      children: [
        const Divider(color: borderColor, height: 1),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFD3D8E0),
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFFD3D8E0),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
