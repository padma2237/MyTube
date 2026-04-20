import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import 'dart:ui';

import 'dart:async';

import 'package:flutter/services.dart';

// MODE SWITCH

class ThemeController extends ChangeNotifier {
ThemeMode _themeMode = ThemeMode.dark;

ThemeMode get themeMode => _themeMode;

void setDark() {
_themeMode = ThemeMode.dark;

notifyListeners();

}

void setLight() {
_themeMode = ThemeMode.light;

notifyListeners();

}

void setGlass() {
_themeMode = ThemeMode.system; // we will treat system as glass mode

notifyListeners();

}
}

final themeController = ThemeController();

void main() {
runApp(const MyApp());
}

// MODEL

class Video {
final String title;

final String url;

Video({required this.title, required this.url});
}

// APP ROOT

class MyApp extends StatelessWidget {
const MyApp({super.key});

@override
Widget build(BuildContext context) {
return AnimatedBuilder(
animation: themeController,

builder: (context, _) {  
    return MaterialApp(  
      debugShowCheckedModeBanner: false,  

      themeMode: themeController.themeMode,  

      builder: (context, child) {  
        final bool isGlass = themeController.themeMode == ThemeMode.system;  

        if (!isGlass) return child!;  

        return Stack(  
          children: [  
            const LiquidBackground(), // moving gradient  

            BackdropFilter(  
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),  

              child: Container(  
                color: Theme.of(context).brightness == Brightness.dark  
                    ? Colors.black.withValues(alpha: 0.2)  
                    : Colors.white.withValues(alpha: 0.2),  
              ), // Fixed withValues  
            ),  

            child!,  
          ],  
        );  
      },  

      // 🌞 LIGHT MODE  
      theme: ThemeData(  
        brightness: Brightness.light,  

        scaffoldBackgroundColor: Colors.white,  

        appBarTheme: const AppBarTheme(  
          backgroundColor: Colors.white,  

          foregroundColor: Colors.black,  

          elevation: 0,  
        ),  

        colorScheme: ColorScheme.fromSwatch(  
          primarySwatch: Colors.blue,  

          brightness: Brightness.light,  
        ).copyWith(secondary: Colors.blueAccent),  

        textTheme: Typography.material2018().black.apply(  
          bodyColor: Colors.black,  

          displayColor: Colors.black,  
        ),  
      ),  

      // 🌑 DARK MODE  
      darkTheme: ThemeData(  
        brightness: Brightness.dark,  

        scaffoldBackgroundColor: Colors.black,  

        appBarTheme: const AppBarTheme(  
          backgroundColor: Colors.black,  

          foregroundColor: Colors.white,  

          elevation: 0,  
        ),  

        colorScheme: ColorScheme.fromSwatch(  
          primarySwatch: Colors.blue,  

          brightness: Brightness.dark,  
        ).copyWith(secondary: Colors.blueAccent),  

        textTheme: Typography.material2018().white.apply(  
          bodyColor: Colors.white,  

          displayColor: Colors.white,  
        ),  
      ),  

      home: const HomeScreen(),  
    );  
  },  
);

}
}

// 🌊 LIQUID BACKGROUND

class LiquidBackground extends StatefulWidget {
const LiquidBackground({super.key});

@override
State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
with SingleTickerProviderStateMixin {
late AnimationController controller;

@override
void initState() {
super.initState();

controller = AnimationController(  
  vsync: this,  

  duration: const Duration(seconds: 6),  
)..repeat();

}

@override
Widget build(BuildContext context) {
return AnimatedBuilder(
animation: controller,

builder: (_, __) {  
    final bool isLight = Theme.of(context).brightness == Brightness.light;  

    return Container(  
      decoration: BoxDecoration(  
        gradient: LinearGradient(  
          begin: Alignment(-1 + controller.value * 2, -1),  

          end: Alignment(1, 1 - controller.value * 2),  

          colors: isLight  
              ? [  
                  Color(0xFF89CFF0), // soft blue  
                  Color(0xFFB0E0E6),  
                  Color(0xFFE0FFFF),  
                ]  
              : [  
                  const Color(0xFF000000),  

                  const Color(0xFF0A0A0A),  

                  const Color(0xFF121212),  
                ],  
        ),  
      ),  
    );  
  },  
);

}

@override
void dispose() {
controller.dispose();

super.dispose();

}
}

// HOME SCREEN

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
Video? miniVideo;

bool showMiniPlayer = false;

VideoPlayerController? miniController;

int currentIndex = 0;

List<Video> videos = <Video>[]; // Explicit type

bool isLoading = true;

String searchQuery = "";
List<String> searchHistory = [];

@override
void initState() {
super.initState();

fetchVideos();

}

Future<void> fetchVideos() async {
setState(() {
isLoading = true;
});

await Future.delayed(const Duration(seconds: 1));  

videos = <Video>[  
  // Explicit type  
  Video(  
    title: "Nature Relaxing Video",  

    url: "https://www.w3schools.com/html/mov_bbb.mp4",  
  ),  

  Video(  
    title: "City Cinematic View",  

    url: "https://www.w3schools.com/html/movie.mp4",  
  ),  

  Video(  
    title: "Peaceful Music",  

    url: "https://www.w3schools.com/html/mov_bbb.mp4",  
  ),  
];  

setState(() {  
  isLoading = false;  
});

}

// Refactored buildHome into a separate widget

// (VideoListContent is defined after HomeScreenState)

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Theme.of(context).scaffoldBackgroundColor,

extendBody: true,  

  extendBodyBehindAppBar: true,  

  appBar: currentIndex == 0  
      ?  
        // APP BAR  
        AppBar(  
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,  

          elevation: 0,  

          title: const Text(  
            "MyTube",  

            style: TextStyle(fontWeight: FontWeight.bold),  
          ),  

          actions: <Widget>[  
            if (searchQuery.isNotEmpty)  
              IconButton(  
                icon: const Icon(Icons.close),  
                onPressed: () {  
                  setState(() {  
                    searchQuery = "";  
                  });  
                },  
              ),  

            // POP UP MENU  

            // Explicit type  
            PopupMenuButton<String>(  
              icon: Icon(  
                Icons.palette,  

                color: Theme.of(context).iconTheme.color,  
              ),  

              onSelected: (String value) {  
                // Explicit type  

                if (value == "dark") themeController.setDark();  

                if (value == "light") themeController.setLight();  

                if (value == "glass") themeController.setGlass();  
              },  

              itemBuilder: (BuildContext context) =>  
                  <PopupMenuEntry<String>>[  
                    // Explicit type  
                    PopupMenuItem<String>(  
                      value: "dark",  
                      child: Row(  
                        children: [  
                          Icon(  
                            Icons.dark_mode,  
                            color:  
                                themeController.themeMode == ThemeMode.dark  
                                ? Colors.white  
                                : Colors.grey,  
                          ),  
                          const SizedBox(width: 10),  
                          Text(  
                            "Dark Mode",  
                            style: TextStyle(  
                              fontWeight:  
                                  themeController.themeMode ==  
                                      ThemeMode.dark  
                                  ? FontWeight.bold  
                                  : FontWeight.normal,  
                            ),  
                          ),  
                        ],  
                      ),  
                    ),  

                    // Explicit type  
                    PopupMenuItem<String>(  
                      value: "light",  
                      child: Row(  
                        children: [  
                          Icon(  
                            Icons.light_mode,  
                            color:  
                                themeController.themeMode == ThemeMode.light  
                                ? Colors.white  
                                : Colors.grey,  
                          ),  
                          const SizedBox(width: 10),  
                          Text(  
                            "Light Mode",  
                            style: TextStyle(  
                              fontWeight:  
                                  themeController.themeMode ==  
                                      ThemeMode.light  
                                  ? FontWeight.bold  
                                  : FontWeight.normal,  
                            ),  
                          ),  
                        ],  
                      ),  
                    ),  

                    // Explicit type  
                    PopupMenuItem<String>(  
                      value: "glass",  
                      child: Row(  
                        children: [  
                          Icon(  
                            Icons.dark_mode,  
                            color:  
                                themeController.themeMode ==  
                                    ThemeMode.system  
                                ? Colors.white  
                                : Colors.grey,  
                          ),  
                          const SizedBox(width: 10),  
                          Text(  
                            "Glass Mode",  
                            style: TextStyle(  
                              fontWeight:  
                                  themeController.themeMode ==  
                                      ThemeMode.system  
                                  ? FontWeight.bold  
                                  : FontWeight.normal,  
                            ),  
                          ),  
                        ],  
                      ),  
                    ),  

                    // SEARCH  

                    // Explicit type  
                  ],  
            ),  

            IconButton(  
              icon: Icon(  
                Icons.search,  

                color: Theme.of(context).iconTheme.color,  

                shadows: themeController.themeMode == ThemeMode.dark  
                    ? [Shadow(color: Colors.blue, blurRadius: 10)]  
                    : [],  
              ),  

              onPressed: () async {  
                await Navigator.push(  
                  context,  
                  MaterialPageRoute(  
                    builder: (_) => SearchScreen(  
                      initialQuery: searchQuery,  
                      history: searchHistory,  
                      onSearch: (query) {  
                        setState(() {  
                          searchQuery = query;  

                          // Save history (no duplicates)  
                          searchHistory.remove(query);  
                          searchHistory.insert(0, query);  
                        });  
                      },  
                    ),  
                  ),  
                );  
              },  
            ),  

            // NOTIFICATION BUTTON  
            IconButton(  
              icon: Icon(  
                Icons.notifications_none,  

                color: Theme.of(context).iconTheme.color,  

                shadows: themeController.themeMode == ThemeMode.dark  
                    ? [Shadow(color: Colors.blue, blurRadius: 10)]  
                    : [],  
              ),  

              onPressed: () async {},  
            ),  
          ],  
        )  
      : null,  

  body: Stack(  
    children: <Widget>[  
      // Explicit type  

      // The background is handled by MyApp's builder or Scaffold's backgroundColor.  

      // No need for a redundant LiquidBackground or Container here.  
      SafeArea(  
        child: currentIndex == 0  
            ? VideoListContent(  
                isLoading: isLoading,  

                videos: videos,  

                searchQuery: searchQuery,  

                onRefresh: fetchVideos,  

                onVideoTap: (Video videoFromPlayerScreen) async {  
                  // Explicit type  

                  // Only update mini-player if the video is different  

                  // or if mini-player is not currently showing this video.  

                  if (miniVideo == null ||  
                      videoFromPlayerScreen.url != miniVideo!.url) {  
                    await miniController?.pause();  

                    await miniController?.dispose();  

                    miniController = null;  

                    miniController = VideoPlayerController.networkUrl(  
                      Uri.parse(videoFromPlayerScreen.url),  
                    );  

                    await miniController!.initialize();  

                    miniController!.setLooping(true);  

                    miniController!.play();  

                    setState(() {  
                      miniVideo = videoFromPlayerScreen;  

                      showMiniPlayer = true;  
                    });  
                  } else {  
                    // If the same video is returned, just ensure mini-player is visible  

                    if (miniController != null &&  
                        !miniController!.value.isPlaying) {  
                      miniController!.play();  
                    }  

                    setState(() {  
                      showMiniPlayer = true;  
                    });  
                  }  
                },  
              )  
            : currentIndex == 1  
            ? const ShortsScreen()  
            : Center(  
                child: Text(  
                  "Profile",  

                  style: TextStyle(  
                    color: Theme.of(context).colorScheme.onSurface,  
                  ), // Using theme-aware color  
                ),  
              ),  
      ),  

      // Mini player  
      if (showMiniPlayer && miniVideo != null && miniController != null)  
        MiniPlayer(  
          video: miniVideo!,  
          controller: miniController!,  

          onTap: () async {  
            final returnedVideo = await Navigator.push(  
              context,  
              MaterialPageRoute(  
                builder: (_) => VideoPlayerScreen(video: miniVideo!),  
              ),  
            );  

            if (!mounted || returnedVideo == null) return;  

            if (returnedVideo.url != miniVideo!.url) {  
              await miniController?.dispose();  

              miniController = VideoPlayerController.networkUrl(  
                Uri.parse(returnedVideo.url),  
              );  

              await miniController!.initialize();  

              if (!mounted) return;  

              miniController!.play();  

              setState(() {  
                miniVideo = returnedVideo;  
              });  
            }  
          },  

          onPlayPause: () {  
            setState(() {  
              miniController!.value.isPlaying  
                  ? miniController!.pause()  
                  : miniController!.play();  
            });  
          },  

          onClose: () {  
            miniController?.dispose();  

            setState(() {  
              miniController = null;  
              miniVideo = null;  
              showMiniPlayer = false;  
            });  
          },  
        ),  
    ],  
  ),  

  // BOTTOM NAV BAR  
  bottomNavigationBar: ClipRRect(  
    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),  

    child: BackdropFilter(  
      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),  

      child: BottomNavigationBar(  
        backgroundColor: Colors.black.withValues(alpha: 0.02),  

        elevation: 0,  

        selectedItemColor: Theme.of(context).iconTheme.color,  

        unselectedItemColor: Theme.of(  
          context,  
        ).iconTheme.color?.withValues(alpha: 0.5),  

        currentIndex: currentIndex,  

        onTap: (int index) {  
          setState(() {  
            currentIndex = index;  

            // ✅ RESET SEARCH when going Home  
            if (index == 0) {  
              searchQuery = "";  
            }  
          });  
        },  

        items: const <BottomNavigationBarItem>[  
          // Explicit type  
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),  

          BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: ""),  

          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),  
        ],  
      ),  
    ),  
  ),  
);

}

@override
void dispose() {
miniController?.dispose();

super.dispose();

}
}

// VIDEO LIST CONTENT (formerly _HomeScreenState.buildHome())

class VideoListContent extends StatelessWidget {
final bool isLoading;

final List<Video> videos;

final String searchQuery;

final RefreshCallback onRefresh;

final ValueChanged<Video> onVideoTap; // Callback for video tap

const VideoListContent({
super.key,

required this.isLoading,  

required this.videos,  

required this.searchQuery,  

required this.onRefresh,  

required this.onVideoTap,

});

@override
Widget build(BuildContext context) {
if (isLoading) {
return const Center(
child: CircularProgressIndicator(color: Colors.white),
);
}

final List<Video> filteredVideos = videos.where((Video video) {  
  // Explicit type  

  return video.title.toLowerCase().contains(searchQuery.toLowerCase());  
}).toList();  

return RefreshIndicator(  
  onRefresh: onRefresh,  

  color: Colors.white,  

  child: ListView.builder(  
    itemCount: filteredVideos.length,  

    itemBuilder: (BuildContext context, int index) {  
      // Explicit types  

      final Video currentVideo = filteredVideos[index];  

      return GestureDetector(  
        onTap: () async {  
          final Video? returnedVideo = await Navigator.push(  
            // Explicit type  
            context,  

            MaterialPageRoute<Video>(  
              // Explicit type  
              builder: (_) => VideoPlayerScreen(video: currentVideo),  
            ),  
          );  

          // If the video player screen returned a video, it means it wants  

          // this video to be played in the mini player.  

          // Pass it up to the HomeScreenState via callback.  

          if (returnedVideo != null) {  
            onVideoTap(returnedVideo);  
          }  
        },  

        child: Column(  
          crossAxisAlignment: CrossAxisAlignment.start,  

          children: <Widget>[  
            // Explicit type  

            // THUMBNAIL  
            Stack(  
              children: <Widget>[  
                // Explicit type  
                Hero(  
                  tag: currentVideo.url,  

                  child: Transform.translate(  
                    offset: Offset(0, index * 5.0),  

                    child: Image.network(  
                      "https://picsum.photos/400/220?random=$index",  

                      width: double.infinity,  

                      height: 220,  

                      fit: BoxFit.cover,  
                    ),  
                  ),  
                ),  

                // SOFT GLOW PLAY 

             Positioned.fill(  
                  child: Center(  
                    child: Container(  
                      decoration: BoxDecoration(  
                        shape: BoxShape.circle,  

                        boxShadow: <BoxShadow>[  
                          // Explicit type  
                          BoxShadow(  
                            color: Colors.white.withValues(  
                              alpha: 0.15,  
                            ), // Fixed withValues  

                            blurRadius: 20,  
                          ),  
                        ],  
                      ),  

                      child: const Icon(  
                        Icons.play_circle_fill,  

                        size: 65,  

                        color: Colors.white,  
                      ),  
                    ),  
                  ),  
                ),  
              ],  
            ),  

            // GLASS CARD  
            ClipRRect(  
              borderRadius: BorderRadius.circular(  
                20,  
              ), // Adjusted radius for better look  

              child: BackdropFilter(  
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),  

                child: Container(  
                  margin: const EdgeInsets.all(10),  

                  decoration: BoxDecoration(  
                    color: Colors.white.withValues(  
                      alpha: 0.08,  
                    ), // Fixed withValues  

                    borderRadius: BorderRadius.circular(20),  

                    border: Border.all(  
                      color: Colors.white.withValues(  
                        alpha: 0.5,  
                      ), // Fixed withValues  
                    ),  

                    boxShadow: <BoxShadow>[  
                      // Explicit type  
                      BoxShadow(  
                        color: Colors.black.withValues(  
                          alpha: 0.5,  
                        ), // Fixed withValues  

                        blurRadius: 20,  

                        offset: const Offset(0, 10),  
                      ),  
                    ],  
                  ),  

                  child: Padding(  
                    padding: const EdgeInsets.all(12),  

                    child: Row(  
                      children: <Widget>[  
                        // Explicit type  
                        CircleAvatar(  
                          backgroundColor: Colors.white24,  

                          child: Icon(  
                            Icons.person,  

                            color: Theme.of(context).iconTheme.color,  
                          ),  
                        ),  

                        const SizedBox(width: 12),  

                        Expanded(  
                          child: Text(  
                            currentVideo.title,  

                            style: TextStyle(  
                              color: Theme.of(  
                                context,  
                              ).textTheme.bodyLarge?.color,  

                              fontWeight: FontWeight.w600,  
                            ),  
                          ),  
                        ),  

                        Icon(  
                          Icons.more_horiz,  

                          color: Theme.of(context).iconTheme.color,  
                        ),  
                      ],  
                    ),  
                  ),  
                ),  
              ),  
            ),  
          ],  
        ),  
      );  
    },  
  ),  
);

}
}

// VIDEO PLAYER

class VideoPlayerScreen extends StatefulWidget {
final Video video;

const VideoPlayerScreen({super.key, required this.video});

@override
State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
late VideoPlayerController controller;

bool showControls = true;

bool isMuted = false;

Timer? hideTimer;

bool isFullScreen = false;

@override
void initState() {
super.initState();

controller = VideoPlayerController.networkUrl(Uri.parse(widget.video.url));  

controller.initialize().then((_) {  
  if (!mounted) return;  

  setState(() {});  

  controller.setVolume(  
    isMuted ? 0.0 : 1.0,  
  ); // Set initial volume based on isMuted  

  controller.play();  

  startHideTimer();  
});

}

void startHideTimer() {
hideTimer?.cancel();

hideTimer = Timer(const Duration(seconds: 3), () {  
  if (mounted) {  
    setState(() {  
      showControls = false;  
    });  
  }  
});

}

void toggleFullScreen() {
setState(() {
isFullScreen = !isFullScreen;
});

if (isFullScreen) {  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);  

  SystemChrome.setPreferredOrientations([  
    DeviceOrientation.landscapeLeft,  
    DeviceOrientation.landscapeRight,  
  ]);  
} else {  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);  

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);  
}

}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,

appBar: AppBar(  
    backgroundColor: Colors.black,  

    title: Text(widget.video.title),  

    actions: <Widget>[  
      // Explicit type  
      IconButton(  
        icon: const Icon(Icons.keyboard_arrow_down),  

        onPressed: () {  
          Navigator.pop(context, widget.video);  
        },  
      ),  
    ],  
  ),  

  body: controller.value.isInitialized  
      ? GestureDetector(  
          onTap: () {  
            setState(() => showControls = true);  

            startHideTimer();  
          },  

          child: Stack(  
            alignment: Alignment.center,  

            children: <Widget>[  
              // Explicit type  

              // 🎬 VIDEO  
              Hero(  
                tag: widget.video.url,  

                child: isFullScreen  
                    ? SizedBox.expand(  
                        child: FittedBox(  
                          fit: BoxFit.cover,  
                          child: SizedBox(  
                            width: controller.value.size.width,  
                            height: controller.value.size.height,  
                            child: VideoPlayer(controller),  
                          ),  
                        ),  
                      )  
                    : AspectRatio(  
                        aspectRatio: controller.value.aspectRatio,  
                        child: VideoPlayer(controller),  
                      ),  
              ),  

              // 🔊 MUTE BUTTON  
              if (showControls)  
                Positioned(  
                  top: 20,  

                  right: 20,  

                  child: IconButton(  
                    icon: Icon(  
                      isMuted ? Icons.volume_off : Icons.volume_up,  

                      color: Colors.white,  
                    ),  

                    onPressed: () {  
                      if (!controller.value.isInitialized) return;  

                      setState(() {  
                        isMuted = !isMuted;  

                        controller.setVolume(isMuted ? 0.0 : 1.0);  
                      });  

                      startHideTimer();  
                    },  
                  ),  
                ),  

              // ▶ PLAY/PAUSE  
              if (showControls)  
                IconButton(  
                  iconSize: 80,  

                  color: Colors.white,  

                  icon: Icon(  
                    controller.value.isPlaying  
                        ? Icons.pause_circle  
                        : Icons.play_circle,  
                  ),  

                  onPressed: () {  
                    setState(() {  
                      controller.value.isPlaying  
                          ? controller.pause()  
                          : controller.play();  
                    });  

                    startHideTimer();  
                  },  
                ),  

              // ⏳ PROGRESS BAR  

                if (showControls)  
                Positioned(  
                  bottom: 0,  

                  left: 0,  

                  right: 0,  

                  child: VideoProgressIndicator(  
                    controller,  

                    allowScrubbing: true,  
                  ),  
                ),  

              if (showControls)  
                Positioned(  
                  bottom: 50,  
                  right: 20,  
                  child: IconButton(  
                    icon: Icon(  
                      isFullScreen  
                          ? Icons.fullscreen_exit  
                          : Icons.fullscreen,  
                      color: Colors.white,  
                    ),  
                    onPressed: () {  
                      toggleFullScreen();  
                      startHideTimer();  
                    },  
                  ),  
                ),  
            ],  
          ),  
        )  
      : const Center(child: CircularProgressIndicator()),  
);

}

@override
void dispose() {
hideTimer?.cancel();

SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);  
SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);  

controller.dispose();  
super.dispose();

}
}

// SHORTS

class ShortsScreen extends StatefulWidget {
const ShortsScreen({super.key});

@override
State<ShortsScreen> createState() => _ShortsScreenState();
}

class _ShortsScreenState extends State<ShortsScreen> {
int currentIndex = 0;

final List<String> videoUrls = <String>[
// Explicit type
"https://www.w3schools.com/html/mov_bbb.mp4",

"https://www.w3schools.com/html/movie.mp4",

];

late PageController pageController;

VideoPlayerController? controller;

int _videoVersion = 0;

@override
void initState() {
super.initState();

pageController = PageController();  

if (videoUrls.isNotEmpty) {  
  initializeVideo(0);  
}

}

void initializeVideo(int index) async {
final int version = ++_videoVersion;

if (index < 0 || index >= videoUrls.length) return;  

await controller?.pause();  

await controller?.dispose();  

controller = null;  

final newController = VideoPlayerController.networkUrl(  
  Uri.parse(videoUrls[index]),  
);  

await newController.initialize();  

// 🛑 STOP OLD async result (THIS PREVENTS MEMORY LEAK)  

if (!mounted || version != _videoVersion) {  
  await newController.dispose();  

  return;  
}  

newController.setLooping(true);  

newController.play();  

setState(() {  
  controller = newController;  
});

}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,

body: PageView.builder(  
    scrollDirection: Axis.vertical,  

    controller: pageController,  

    itemCount: videoUrls.length,  

    onPageChanged: (int index) {  
      controller?.pause(); // STOP OLD VIDEO IMMEDIATELY  

      setState(() {  
        currentIndex = index;  
      });  

      initializeVideo(index);  
    },  

    itemBuilder: (BuildContext context, int index) {  
      // Explicit types  

      // The pageController.page can be null before the first layout.  

      // Using a default of 0.0 or handling null directly.  

      final bool isCurrentPage = index == currentIndex;  

      final bool isReady =  
          isCurrentPage && (controller?.value.isInitialized ?? false);  

      return GestureDetector(  
        onTap: () {  
          if (controller != null && controller!.value.isInitialized) {  
            if (controller!.value.isPlaying) {  
              controller!.pause();  
            } else {  
              controller!.play();  
            }  

            setState(  
              () {},  
            ); // Rebuild to show updated play/pause state if needed  
          }  
        },  

        child: Stack(  
          children: <Widget>[  
            // Explicit type  
            Center(  
              child: isReady  
                  ? AspectRatio(  
                      aspectRatio: controller!.value.aspectRatio,  

                      child: VideoPlayer(controller!),  
                    )  
                  : const CircularProgressIndicator(),  
            ),  

            Positioned(  
              right: 10,  

              bottom: 100,  

              child: Column(  
                children: <Widget>[  
                  // Explicit type  
                  _GlowIcon(icon: Icons.favorite), // Use _GlowIcon widget  

                  const SizedBox(height: 20),  

                  _GlowIcon(icon: Icons.comment), // Use _GlowIcon widget  

                  const SizedBox(height: 20),  

                  _GlowIcon(icon: Icons.share), // Use _GlowIcon widget  
                ],  
              ),  
            ),  
          ],  
        ),  
      );  
    },  
  ),  
);

}

@override
void dispose() {
_videoVersion++; // cancel async callbacks

controller?.pause();  

controller?.dispose();  

pageController.dispose();  

super.dispose();

}
}

// _GlowIcon widget for reuse

class _GlowIcon extends StatelessWidget {
final IconData icon;

const _GlowIcon({required this.icon});

@override
Widget build(BuildContext context) {
return Container(
decoration: BoxDecoration(
shape: BoxShape.circle,

boxShadow: <BoxShadow>[  
      // Explicit type  
      BoxShadow(  
        color: Colors.white.withValues(alpha: 0.2),  

        blurRadius: 15,  
      ), // Fixed withValues  
    ],  
  ),  

  child: Icon(icon, color: Colors.white, size: 30),  
);

}
}

// Search screen

class SearchScreen extends StatefulWidget {
final ValueChanged<String> onSearch;
final List<String> history;
final String initialQuery;

const SearchScreen({
super.key,
required this.onSearch,
required this.history,
required this.initialQuery,
});

@override
State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
late TextEditingController controller;

List<String> suggestions = [
"music",
"love",
"study",
"city",
"relax",
"gaming",
"motivation",
"nature",
];

@override
void initState() {
super.initState();
controller = TextEditingController(text: widget.initialQuery);
}

@override
Widget build(BuildContext context) {
final query = controller.text.toLowerCase();

final filteredSuggestions = suggestions  
    .where((s) => s.contains(query))  
    .toList();  

return Scaffold(  
  backgroundColor: Colors.black,  
  appBar: AppBar(  
    backgroundColor: Colors.black,  
    title: TextField(  
      controller: controller,  
      autofocus: true,  
      style: const TextStyle(color: Colors.white),  
      decoration: InputDecoration(  
        hintText: "Search videos...",  
        hintStyle: const TextStyle(color: Colors.white54),  
        border: InputBorder.none,  
        suffixIcon: controller.text.isNotEmpty  
            ? IconButton(  
                icon: const Icon(Icons.clear, color: Colors.white),  
                onPressed: () {  
                  controller.clear();  
                  setState(() {});  
                },  
              )  
            : null,  
      ),  
      onChanged: (value) {  
        setState(() {});  
        widget.onSearch(value);  
      },  
    ),  
  ),  

  body: ListView(  
    children: [  
      // 🔥 Suggestions  
      if (query.isNotEmpty)  
        ...filteredSuggestions.map(  
          (s) => ListTile(  
            leading: const Icon(Icons.search, color: Colors.white54),  
            title: Text(s, style: const TextStyle(color: Colors.white)),  
            onTap: () {  
              widget.onSearch(s);  
              Navigator.pop(context);  
            },  
          ),  
        ),  

      // 🕘 History  
      if (query.isEmpty && widget.history.isNotEmpty)  
        const Padding(  
          padding: EdgeInsets.all(12),  
          child: Text(  
            "Recent Searches",  
            style: TextStyle(color: Colors.white54),  
          ),  
        ),  

      if (query.isEmpty)  
        ...widget.history.map(  
          (h) => ListTile(  
            leading: const Icon(Icons.history, color: Colors.white54),  
            title: Text(h, style: const TextStyle(color: Colors.white)),  
            trailing: IconButton(  
              icon: const Icon(Icons.close, color: Colors.white54),  
              onPressed: () {  
                setState(() {  
                  widget.history.remove(h);  
                });  
              },  
            ),  
            onTap: () {  
              widget.onSearch(h);  
              Navigator.pop(context);  
            },  
          ),  
        ),  
    ],  
  ),  
);

}
}

// class mini player

class MiniPlayer extends StatefulWidget {
final Video video;
final VideoPlayerController controller;
final VoidCallback onClose;
final VoidCallback onTap;
final VoidCallback onPlayPause;

const MiniPlayer({
super.key,
required this.video,
required this.controller,
required this.onClose,
required this.onTap,
required this.onPlayPause,
});

@override
State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
double offsetY = 0;

@override
Widget build(BuildContext context) {
return AnimatedPositioned(
duration: const Duration(milliseconds: 200),
bottom: 80 - offsetY,
right: 10,
child: GestureDetector(
onVerticalDragUpdate: (details) {
setState(() {
offsetY += details.delta.dy;
offsetY = offsetY.clamp(0, 200);
});
},

onVerticalDragEnd: (details) {  
      if (offsetY > 120) {  
        widget.onClose(); // swipe down → close  
      } else if (offsetY < 20) {  
        widget.onTap(); // swipe up → open full  
      }  

      setState(() {  
        offsetY = 0;  
      });  
    },  

    child: Container(  
      width: 180,  
      height: 100,  
      decoration: BoxDecoration(  
        color: Colors.black,  
        borderRadius: BorderRadius.circular(12),  
        boxShadow: [  
          BoxShadow(  
            color: Colors.black.withValues(alpha: 0.5),  
            blurRadius: 10,  
          ),  
        ],  
      ),  

      child: Stack(  
        children: [  
          GestureDetector(  
            onTap: widget.onTap,  
            child: ClipRRect(  
              borderRadius: BorderRadius.circular(12),  
              child: widget.controller.value.isInitialized  
                  ? AspectRatio(  
                      aspectRatio: widget.controller.value.aspectRatio,  
                      child: VideoPlayer(widget.controller),  
                    )  
                  : const Center(child: CircularProgressIndicator()),  
            ),  
          ),  

          Positioned(  
            top: 5,  
            right: 5,  
            child: Row(  
              children: [  
                GestureDetector(  
                  onTap: widget.onPlayPause,  
                  child: Icon(  
                    widget.controller.value.isPlaying  
                        ? Icons.pause  
                        : Icons.play_arrow,  
                    color: Colors.white,  
                    size: 18,  
                  ),  
                ),  
                const SizedBox(width: 8),  
                GestureDetector(  
                  onTap: widget.onClose,  
                  child: const Icon(  
                    Icons.close,  
                    color: Colors.white,  
                    size: 18,  
                  ),  
                ),  
              ],  
            ),  
          ),  
        ],  
      ),  
    ),  
  ),  
);

}
}
