import 'package:flutter/material.dart';
import 'dart:ui';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool darkMode = false;
  bool adBlock = true;
  bool saveHistory = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeaturedSettings(),
                      const SizedBox(height: 32),
                      _buildSettingsList(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Settings',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        
        // Featured settings grid
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.dark_mode_rounded,
                title: 'Dark Mode',
                subtitle: darkMode ? 'On' : 'Off',
                gradient: [Colors.indigo.shade400, Colors.indigo.shade600],
                onTap: () {
                  setState(() => darkMode = !darkMode);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.block_rounded,
                title: 'Ad Block',
                subtitle: adBlock ? 'Enabled' : 'Disabled',
                gradient: [Colors.red.shade400, Colors.red.shade600],
                onTap: () {
                  setState(() => adBlock = !adBlock);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.history_rounded,
                title: 'History',
                subtitle: '${saveHistory ? "Saving" : "Not saving"}',
                gradient: [Colors.green.shade400, Colors.green.shade600],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HistoryView()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.bookmark_rounded,
                title: 'Bookmarks',
                subtitle: 'View all',
                gradient: [Colors.orange.shade400, Colors.orange.shade600],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookmarksView()),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: gradient.first.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Settings',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        
        _buildSettingsSection(
          title: 'Privacy & Security',
          items: [
            SettingItem(
              icon: Icons.shield_rounded,
              title: 'Clear Browsing Data',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.cookie_rounded,
              title: 'Cookies',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.location_on_rounded,
              title: 'Site Permissions',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _buildSettingsSection(
          title: 'Appearance',
          items: [
            SettingItem(
              icon: Icons.format_size_rounded,
              title: 'Text Size',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.palette_rounded,
              title: 'Theme',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _buildSettingsSection(
          title: 'Advanced',
          items: [
            SettingItem(
              icon: Icons.download_rounded,
              title: 'Downloads',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.language_rounded,
              title: 'Languages',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.search_rounded,
              title: 'Search Engine',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        _buildSettingsSection(
          title: 'About',
          items: [
            SettingItem(
              icon: Icons.info_rounded,
              title: 'Version',
              subtitle: '1.0.0',
              onTap: () {},
            ),
            SettingItem(
              icon: Icons.feedback_rounded,
              title: 'Send Feedback',
              trailing: Icons.arrow_forward_ios_rounded,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<SettingItem> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white.withOpacity(0.1),
                  height: 1,
                  indent: 56,
                ),
                itemBuilder: (context, index) => _buildSettingItem(items[index]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(SettingItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.trailing != null)
              Icon(
                item.trailing,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
          ],
        ),
      ),
    );
  }
}

class SettingItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final IconData? trailing;
  final VoidCallback onTap;

  SettingItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });
}

// History View
class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHistorySection('Today', [
            'Flutter Documentation - flutter.dev',
            'Google Search - google.com',
          ]),
          const SizedBox(height: 20),
          _buildHistorySection('Yesterday', [
            'YouTube - youtube.com',
            'GitHub - github.com',
          ]),
        ],
      ),
    );
  }

  Widget _buildHistorySection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => ListTile(
          leading: const Icon(Icons.history_rounded),
          title: Text(item),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        )),
      ],
    );
  }
}

// Bookmarks View
class BookmarksView extends StatelessWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Bookmarks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildBookmarkCard('Flutter', Icons.code_rounded, Colors.blue),
          _buildBookmarkCard('GitHub', Icons.code_off_rounded, Colors.black),
          _buildBookmarkCard('YouTube', Icons.play_circle_outline_rounded, Colors.red),
        ],
      ),
    );
  }

  Widget _buildBookmarkCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
