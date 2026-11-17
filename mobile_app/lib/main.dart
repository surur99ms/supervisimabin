import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'widgets/premium_splash_overlay.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SupervisiMabinApp());
}

class SupervisiMabinApp extends StatelessWidget {
  const SupervisiMabinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supervisi Mabin IASS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFFFF416C),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: const WebAppScreen(),
    );
  }
}

class WebAppScreen extends StatefulWidget {
  const WebAppScreen({super.key});

  @override
  State<WebAppScreen> createState() => _WebAppScreenState();
}

class _WebAppScreenState extends State<WebAppScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  double _progress = 0;
  String _currentUrl = 'http://192.168.1.12/supervisimabin/';
  DateTime? _lastBackPressTime;

  // Splash Screen Transition State
  bool _splashComplete = false;
  bool _pageLoaded = false;
  bool _minTimeElapsed = false;

  bool get _isReadyForTransition => _pageLoaded && _minTimeElapsed;

  static const String keySavedUrl = 'saved_web_url';
  static const String localUrl = 'http://192.168.1.12/supervisimabin/';
  static const String productionUrl = 'https://supervisi.mabin.corefive.my.id/';

  @override
  void initState() {
    super.initState();

    // Minimum display duration for the splash transition (2.2s)
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) setState(() => _minTimeElapsed = true);
    });

    // Fallback safety timeout in case of slow initial network
    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted && !_pageLoaded) setState(() => _pageLoaded = true);
    });

    _initWebView();
  }

  Future<void> _initWebView() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(keySavedUrl) ?? localUrl;
    _currentUrl = saved;

    final WebViewController controller = WebViewController();

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF4F6F9))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _progress = progress / 100.0;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
              _pageLoaded = true;
            });

            // Ensure exact edge-to-edge layout on mobile
            controller.runJavaScript('''
              (function() {
                if (!document.getElementById('mobile-app-custom-style')) {
                  const style = document.createElement('style');
                  style.id = 'mobile-app-custom-style';
                  style.innerHTML = `
                    html, body {
                      margin: 0 !important;
                      padding: 0 !important;
                      width: 100% !important;
                      height: 100% !important;
                      background: #f4f6f9 !important;
                      overflow: hidden !important;
                    }
                    body.dark-mode {
                      background: #1a1b1e !important;
                    }
                    .app-container {
                      width: 100% !important;
                      max-width: 100% !important;
                      height: 100% !important;
                      max-height: 100% !important;
                      border: none !important;
                      border-radius: 0 !important;
                      box-shadow: none !important;
                    }
                  `;
                  document.head.appendChild(style);
                }
              })();
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebResourceError: \${error.description}');
            // Fallback so user is not stuck on splash if an error occurs
            if (mounted) setState(() => _pageLoaded = true);
          },
          onNavigationRequest: (NavigationRequest request) async {
            final url = request.url;
            if (url.startsWith('https://wa.me') ||
                url.startsWith('whatsapp://') ||
                url.startsWith('tel:') ||
                url.startsWith('mailto:')) {
              try {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              } catch (_) {}
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(_currentUrl));

    _controller = controller;
  }

  Future<void> _switchUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keySavedUrl, url);
    setState(() {
      _currentUrl = url;
      _isLoading = true;
    });
    _controller.loadRequest(Uri.parse(url));
  }

  void _showServerDialog() {
    final urlController = TextEditingController(text: _currentUrl);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pengaturan Server Web', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Pilih URL server Supervisi Mabin:', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 10),
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: 'URL Server',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      urlController.text = localUrl;
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.blueGrey.shade50,
                      foregroundColor: Colors.blueGrey.shade800,
                    ),
                    child: const Text('Local Laragon', style: TextStyle(fontSize: 11)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      urlController.text = productionUrl;
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.blueGrey.shade50,
                      foregroundColor: Colors.blueGrey.shade800,
                    ),
                    child: const Text('Production', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final newUrl = urlController.text.trim();
              if (newUrl.isNotEmpty) {
                Navigator.pop(ctx);
                _switchUrl(newUrl);
              }
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;

        if (await _controller.canGoBack()) {
          _controller.goBack();
          return;
        }

        final now = DateTime.now();
        if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tekan sekali lagi untuk keluar dari aplikasi'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        SystemNavigator.pop();
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // 1. Preloaded WebView (running underneath)
              RefreshIndicator(
                onRefresh: () async {
                  _controller.reload();
                },
                child: WebViewWidget(controller: _controller),
              ),

              // 2. Loading bar for in-app page reloads (after splash)
              if (_isLoading && _splashComplete)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: _progress > 0 ? _progress : null,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF416C)),
                    minHeight: 3,
                  ),
                ),

              // 3. Subtle Server Settings button (visible once in app)
              if (_splashComplete)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Opacity(
                    opacity: 0.35,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _showServerDialog,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.settings, size: 18, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),

              // 4. Premium Splash Screen Overlay (smoothly morphs into Home Screen)
              if (!_splashComplete)
                PremiumSplashOverlay(
                  isReady: _isReadyForTransition,
                  onTransitionComplete: () {
                    if (mounted) {
                      setState(() {
                        _splashComplete = true;
                      });
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
