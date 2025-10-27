import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Photo {
  final String id;
  final String url;
  final String title;
  bool isFavorite;

  Photo({
    required this.id,
    required this.url,
    required this.title,
    this.isFavorite = false,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gesture Photo Viewer',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      home: const PhotoViewerPage(),
    );
  }
}

class PhotoViewerPage extends StatefulWidget {
  const PhotoViewerPage({super.key});

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  final List<Photo> _photos = [
    Photo(
      id: '1',
      url:
          'https://fastly.picsum.photos/id/1015/600/400.jpg?hmac=tPonaXlfk6h4b60UAWLppeEvDelLS838XzWucEdHk5o',
      title: 'Mountain View',
    ),
    Photo(
      id: '2',
      url:
          'https://fastly.picsum.photos/id/1016/600/400.jpg?hmac=5WpKQcch6b9jPsbUmTUUaqDNh1rJNSk1J3ou64QfVhY',
      title: 'Sunset',
    ),
    Photo(
      id: '3',
      url: 'https://picsum.photos/id/1018/600/400',
      title: 'Forest Path',
    ),
    Photo(
      id: '4',
      url:
          'https://fastly.picsum.photos/id/1020/600/400.jpg?hmac=PPj6tRvCC2emb9O0Z36dHmJM1EBg04og4wUl1HF1w64',
      title: 'Bear',
    ),
  ];

  int _currentIndex = 0; // tracks the current photot
  bool _showDetails = true;
  bool _isZoomed = false;

  // 1. gesture tap
  void _handleTap() {
    setState(() {
      _showDetails = !_showDetails;
    });
    _showFeedback('Details ${_showDetails ? 'Shown' : 'Hidden'}');
  }

  // 2 gesture double tap
  void _handleDoubleTap() {
    setState(() {
      _isZoomed = !_isZoomed;
    });
    _showFeedback('Zoom ${_isZoomed ? 'In' : 'Out'}');
  }

  // 3 gesture long press
  void _handleLongPress() {
    setState(() {
      _photos[_currentIndex].isFavorite = !_photos[_currentIndex].isFavorite;
    });
    _showFeedback(
      _photos[_currentIndex].isFavorite
          ? 'Added to Favorites'
          : 'Removed from Favorites',
    );
  }

  // 4 gestire swipe
  void _handleHorizontalSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    if (details.primaryVelocity! < -100) {
      // Swipe Left

      if (_currentIndex < _photos.length - 1) {
        setState(() {
          _currentIndex++;
          _isZoomed = false;
          _showDetails = true;
        });
      }
    } else if (details.primaryVelocity! > 100) {
      // Swipe Right
      if (_currentIndex > 0) {
        setState(() {
          _currentIndex--;
          _isZoomed = false;
          _showDetails = true;
        });
      }
    }
  }

  // 5 helper to show a snackbar feedback message
  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Photo currentPhoto = _photos[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Viewer (${_currentIndex + 1}/${_photos.length})'),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: _handleTap,
          onDoubleTap: _handleDoubleTap,
          onLongPress: _handleLongPress,
          onHorizontalDragEnd: _handleHorizontalSwipe,

          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                // Apply a zoom transformation if _isZoomed is true
                transform: _isZoomed
                    ? (Matrix4.identity()..scale(1.5)) // Zoom in 1.5x
                    : Matrix4.identity(), // Normal size
                transformAlignment: Alignment.center,
                child: Image.network(
                  currentPhoto.url,
                  fit: BoxFit.contain,
                  // Show a loading spinner while the image loads
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              // Favorite Icon (Top Right)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: currentPhoto.isFavorite ? 1.0 : 0.0,
                child: Positioned(
                  top: 16,
                  right: 16,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 40,
                    shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
                  ),
                ),
              ),

              // Photo Title (Bottom)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showDetails ? 1.0 : 0.0,
                child: Positioned(
                  bottom: 30,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      currentPhoto.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
