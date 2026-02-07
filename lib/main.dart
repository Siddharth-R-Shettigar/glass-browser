import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';
import 'screens/search_panel.dart';
import 'screens/browser_view.dart';
import 'screens/tabs_view.dart';
import 'screens/settings_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const GlassBrowserApp());
}

class GlassBrowserApp extends StatelessWidget {
  const GlassBrowserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glass Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        fontFamily: 'SF Pro Display',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        fontFamily: 'SF Pro Display',
      ),
      themeMode: ThemeMode.system,
      home: const BrowserHomePage(),
    );
  }
  @override
Widget build(BuildContext context) {
  // 1. Wrap the Scaffold with PopScope
  return PopScope(
    canPop: false, // Prevents the app from closing immediately
    onPopInvokedWithResult: (didPop, result) async {
      // If the pop already happened, do nothing
      if (didPop) return;

      // 2. Check if the browser can go back
      if (await _webViewController.canGoBack()) {
        await _webViewController.goBack(); // Navigate back in the browser
      } else {
        // 3. If the browser can't go back, close the app
        SystemNavigator.pop(); 
      }
    },
    child: Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Your existing Stack content (WebView, search bar, etc.)
          _buildWebView(),
          _buildUI(),
        ],
      ),
    ),
  );
}

class BrowserHomePage extends StatefulWidget {
  const BrowserHomePage({super.key});

  @override
  State<BrowserHomePage> createState() => _BrowserHomePageState();
}

class _BrowserHomePageState extends State<BrowserHomePage> with TickerProviderStateMixin {
  late WebViewController _webViewController;
  bool _showSearchPanel = true;
  late AnimationController _panelController;
  late Animation<double> _panelAnimation;
  String _currentUrl = 'https://www.google.com';
  List<String> _recentSearches = [
    'Flutter development',
    'Best restaurants near me',
    'Weather forecast',
    'News today',
  ];
  
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    // Initialize WebView
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setDomStorageEnabled(true)
      ..enableZoom(true)
      ..loadRequest(Uri.parse(_currentUrl));

    // Panel animation controller
    _panelController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _panelAnimation = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeOutCubic,
    );

    // Show panel on start
    _panelController.forward();
    
    // Auto-focus search bar
    Future.delayed(const Duration(milliseconds: 500), () {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _panelController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _openUrl(String query) {
    String url = query;
    if (!query.startsWith('http://') && !query.startsWith('https://')) {
      // Check if it's a URL or search query
      if (query.contains('.') && !query.contains(' ')) {
        url = 'https://$query';
      } else {
        url = 'https://www.google.com/search?q=${Uri.encodeComponent(query)}';
      }
    }
    
    setState(() {
      _currentUrl = url;
      _showSearchPanel = false;
      // Add to recent searches
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      }
    });
    
    _webViewController.loadRequest(Uri.parse(url));
    _panelController.reverse();
    _searchFocusNode.unfocus();
  }

  void _showSearchPanelAgain() {
    setState(() {
      _showSearchPanel = true;
    });
    _panelController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _navigateToTabs() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TabsView()),
    );
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // WebView Background
          Positioned.fill(
            child: WebViewWidget(controller: _webViewController),
          ),
          
          // Search Panel with Liquid Glass Effect
          AnimatedBuilder(
            animation: _panelAnimation,
            builder: (context, child) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).size.height * (1 - _panelAnimation.value * 0.75),
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 500) {
                      // Swipe down to close
                      setState(() {
                        _showSearchPanel = false;
                      });
                      _panelController.reverse();
                      _searchFocusNode.unfocus();
                    }
                  },
                  child: SearchPanel(
                    searchController: _searchController,
                    searchFocusNode: _searchFocusNode,
                    recentSearches: _recentSearches,
                    onSearch: _openUrl,
                    onRecentSearchTap: (search) {
                      _searchController.text = search;
                      _openUrl(search);
                    },
                  ),
                ),
              );
            },
          ),
          
          // Bottom Navigation Bar
          if (!_showSearchPanel)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomBar(),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(0.6)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomBarButton(
                icon: Icons.tab_rounded,
                label: 'Tabs',
                onTap: _navigateToTabs,
              ),
              _buildPlusButton(),
              _buildBottomBarButton(
                icon: Icons.more_horiz_rounded,
                label: 'Menu',
                onTap: () => _showMenuSheet(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlusButton() {
    return InkWell(
      onTap: _showSearchPanelAgain,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          size: 28,
          color: Colors.white,
        ),
      ),
    );
  }

  void _showMenuSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => MenuBottomSheet(
        onSettingsTap: _navigateToSettings,
        webViewController: _webViewController,
      ),
    );
  }
}

// Menu Bottom Sheet (Comet-style)
// Menu Bottom Sheet (Corrected Scope and API)
class MenuBottomSheet extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final WebViewController webViewController;

  const MenuBottomSheet({
    super.key,
    required this.onSettingsTap,
    required this.webViewController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(0.85)
            : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Row 1: Reload & Desktop
              Row(
                children: [
                  Expanded(
                    child: _buildMenuButton(
                      context,
                      icon: Icons.refresh_rounded,
                      label: 'Reload',
                      onTap: () {
                        webViewController.reload();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMenuButton(
                      context,
                      icon: Icons.desktop_windows_rounded,
                      label: 'Desktop Site',
                      onTap: () {
                        webViewController.setUserAgent(
                            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36");
                        webViewController.reload();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: Zoom Actions (Fixed via JavaScript)
              Row(
                children: [
                  Expanded(
                    child: _buildMenuButton(
                      context,
                      icon: Icons.zoom_in_rounded,
                      label: 'Zoom In',
                      onTap: () {
                        // Bypassing API constraint using JS injection
                        webViewController.runJavaScript(
                            "document.body.style.zoom = (parseFloat(document.body.style.zoom || 1) + 0.1).toString()");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMenuButton(
                      context,
                      icon: Icons.zoom_out_rounded,
                      label: 'Zoom Out',
                      onTap: () {
                        webViewController.runJavaScript(
                            "document.body.style.zoom = (parseFloat(document.body.style.zoom || 1) - 0.1).toString()");
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 12),

              // Settings button
              _buildLargeMenuButton(
                context,
                icon: Icons.settings_rounded,
                label: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  onSettingsTap();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MOVED THESE METHODS INSIDE THE CLASS SO THEY ARE ACCESSIBLE
  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
