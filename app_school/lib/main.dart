import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:clay_containers/clay_containers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App School',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFE0E5EC),
        useMaterial3: true,
      ),
      home: const UrlInputScreen(),
    );
  }
}

// Primera pantalla para ingresar URL
class UrlInputScreen extends StatefulWidget {
  const UrlInputScreen({super.key});

  @override
  State<UrlInputScreen> createState() => _UrlInputScreenState();
}

class _UrlInputScreenState extends State<UrlInputScreen> {
  final TextEditingController _urlController = TextEditingController();

  void _navigateToWeb() {
    String url = _urlController.text;
    if (url.isEmpty) return;

    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color baseColor = const Color(0xFFE0E5EC);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 0,
        title: const Text('App School', 
          style: TextStyle(color: Color(0xFF5D7599), fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF5D7599),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ingrese la dirección web que desea visitar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7B8BAA),
                ),
              ),
              const SizedBox(height: 40),
              ClayContainer(
                depth: 20,
                color: baseColor,
                spread: 5,
                borderRadius: 12,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese la URL aquí',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    style: const TextStyle(color: Color(0xFF5D7599)),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.go,
                    onSubmitted: (_) => _navigateToWeb(),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ClayContainer(
                height: 60,
                width: 200,
                depth: 40,
                borderRadius: 30,
                curveType: CurveType.concave,
                color: baseColor,
                child: TextButton(
                  onPressed: _navigateToWeb,
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: const Text(
                    'NAVEGAR',
                    style: TextStyle(
                      color: Color(0xFF5D7599),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Segunda pantalla para mostrar el WebView
class WebViewScreen extends StatefulWidget {
  final String url;
  
  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  WebViewController? _webViewController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Inicializar el controlador WebView
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0E5EC),
        elevation: 0,
        title: const Text('App School', 
          style: TextStyle(color: Color(0xFF5D7599), fontWeight: FontWeight.bold),
        ),
        leading: ClayContainer(
          height: 40,
          width: 40,
          depth: 15,
          borderRadius: 40,
          curveType: CurveType.concave,
          color: const Color(0xFFE0E5EC),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF5D7599)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ClayContainer(
              height: 40,
              width: 40,
              depth: 15,
              borderRadius: 40,
              curveType: CurveType.concave,
              color: const Color(0xFFE0E5EC),
              child: IconButton(
                icon: const Icon(Icons.home, color: Color(0xFF5D7599)),
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isLoading)
            LinearProgressIndicator(
              backgroundColor: const Color(0xFFE0E5EC),
              color: Theme.of(context).colorScheme.primary,
            ),
          Expanded(
            child: _webViewController != null
                ? WebViewWidget(controller: _webViewController!)
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}