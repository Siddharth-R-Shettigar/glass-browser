import 'package:flutter/material.dart';
import 'dart:ui';

class TabsView extends StatefulWidget {
  const TabsView({super.key});

  @override
  State<TabsView> createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  // Regular Tabs List
  List<BrowserTab> tabs = [
    BrowserTab(
      id: '1',
      title: 'Google',
      url: 'https://www.google.com',
      favicon: Icons.search_rounded,
    ),
    BrowserTab(
      id: '2',
      title: 'YouTube',
      url: 'https://www.youtube.com',
      favicon: Icons.play_circle_outline_rounded,
    ),
  ];

  // Incognito Tabs List
  List<BrowserTab> incognitoTabs = [];
  bool showIncognito = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // Dynamic background based on mode
      backgroundColor: showIncognito ? Colors.grey[900] : Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: showIncognito 
              ? [Colors.black, Colors.grey[900]!]
              : [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: _buildTabsGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    int currentCount = showIncognito ? incognitoTabs.length : tabs.length;
    
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: showIncognito ? Colors.white : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                '$currentCount ${showIncognito ? 'Private' : ''} Tabs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: showIncognito ? Colors.white : Theme.of(context).colorScheme.onSurface,
                ),
              ),
              IconButton(
                onPressed: _addNewTab,
                icon: Icon(
                  Icons.add_circle_outline_rounded,
                  color: showIncognito ? Colors.white : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Glassmorphic Tab Switcher
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: showIncognito 
                  ? Colors.white.withOpacity(0.1) 
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabTypeButton(
                    label: 'Regular',
                    icon: Icons.public_rounded,
                    isSelected: !showIncognito,
                    onTap: () => setState(() => showIncognito = false),
                  ),
                ),
                Expanded(
                  child: _buildTabTypeButton(
                    label: 'Incognito',
                    icon: Icons.security_rounded,
                    isSelected: showIncognito,
                    onTap: () => setState(() => showIncognito = true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addNewTab() {
    setState(() {
      final newTab = BrowserTab(
        id: DateTime.now().toString(),
        title: 'New Tab',
        url: 'https://www.google.com',
        favicon: Icons.language_rounded,
      );
      
      if (showIncognito) {
        incognitoTabs.add(newTab);
      } else {
        tabs.add(newTab);
      }
    });
  }

  Widget _buildTabTypeButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (showIncognito ? Colors.white : Theme.of(context).colorScheme.primary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? (showIncognito ? Colors.black : Colors.white)
                  : (showIncognito ? Colors.white70 : Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? (showIncognito ? Colors.black : Colors.white)
                    : (showIncognito ? Colors.white70 : Theme.of(context).colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabsGrid() {
    final activeList = showIncognito ? incognitoTabs : tabs;

    if (activeList.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: activeList.length,
      itemBuilder: (context, index) => _buildTabCard(activeList[index], index),
    );
  }

  Widget _buildTabCard(BrowserTab tab, int index) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: showIncognito ? Colors.white24 : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: showIncognito ? Colors.white10 : Colors.white.withOpacity(0.1),
              child: Stack(
                children: [
                  Center(
                    child: Icon(tab.favicon, 
                      size: 40, 
                      color: showIncognito ? Colors.white54 : Theme.of(context).colorScheme.primary
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.black26,
                      child: Text(
                        tab.title,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (showIncognito) {
                            incognitoTabs.removeAt(index);
                          } else {
                            tabs.removeAt(index);
                          }
                        });
                      },
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black45,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            showIncognito ? Icons.security_rounded : Icons.tab_unselected_rounded,
            size: 64,
            color: showIncognito ? Colors.white24 : Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            showIncognito ? 'No Private Tabs' : 'No Open Tabs',
            style: TextStyle(color: showIncognito ? Colors.white : Colors.grey),
          ),
        ],
      ),
    );
  }
}

class BrowserTab {
  final String id;
  final String title;
  final String url;
  final IconData favicon;

  BrowserTab({
    required this.id,
    required this.title,
    required this.url,
    required this.favicon,
  });
}
