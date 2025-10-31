import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class _AnimationSet {
  final String simpleUrl;
  final String controlledUrl;
  final String highFpsUrl;
  final String delegatesUrl;

  const _AnimationSet({
    required this.simpleUrl,
    required this.controlledUrl,
    required this.highFpsUrl,
    required this.delegatesUrl,
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late final AnimationController _controller;
  bool _loop = true;
  late Map<String, _AnimationSet> _exampleSets;
  late String _selectedSetKey;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _exampleSets = {
      'Letters A to D': const _AnimationSet(
        simpleUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
        controlledUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/B.json',
        highFpsUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/C.json',
        delegatesUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/D.json',
      ),
      'Letters E to H': const _AnimationSet(
        simpleUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/E.json',
        controlledUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/F.json',
        highFpsUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/G.json',
        delegatesUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/H.json',
      ),
      'General': const _AnimationSet(
        simpleUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/LottieLogo1.json',
        controlledUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/HamburgerArrow.json',
        highFpsUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/PinJump.json',
        delegatesUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/SwitchTheme.json',
      ),
      'Weather': const _AnimationSet(
        simpleUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/weather/fog.json',
        controlledUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/weather/hurricane.json',
        highFpsUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/weather/thunder-storm.json',
        delegatesUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/weather/tornado.json',
      ),
      'Loaders': const _AnimationSet(
        simpleUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/loading.json',
        controlledUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/cube_loader.json',
        highFpsUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/lottiefiles/lego_loader.json',
        delegatesUrl:
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Tests/Shapes.json',
      ),
    };
    _selectedSetKey = 'Letters A to D';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lottie Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('MTL Lottie Demo')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Text('Example set'),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _selectedSetKey,
                      items: _exampleSets.keys
                          .map(
                            (k) => DropdownMenuItem<String>(
                              value: k,
                              child: Text(k),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedSetKey = value;
                          _controller
                            ..stop()
                            ..value = 0.0;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Simple animation (network)'),
                    const SizedBox(height: 8),
                    Center(
                      child: Lottie.network(
                        _exampleSets[_selectedSetKey]!.simpleUrl,
                        height: 180,
                        repeat: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Controlled animation (network + AnimationController)',
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Lottie.network(
                        _exampleSets[_selectedSetKey]!.controlledUrl,
                        controller: _controller,
                        onLoaded: (composition) {
                          _controller
                            ..duration = composition.duration
                            ..repeat();
                        },
                        height: 180,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _Controls(
                      isLooping: _loop,
                      isAnimating: _controller.isAnimating,
                      progress: _controller.value,
                      onPlay: () {
                        if (_loop) {
                          _controller.repeat();
                        } else {
                          _controller.forward();
                        }
                      },
                      onPause: _controller.stop,
                      onReset: () {
                        _controller
                          ..stop()
                          ..value = 0.0;
                      },
                      onToggleLoop: (v) {
                        setState(() {
                          _loop = v;
                        });
                        if (_controller.isAnimating) {
                          if (v) {
                            _controller.repeat();
                          } else {
                            _controller.stop();
                          }
                        }
                      },
                      onScrub: (v) {
                        setState(() {
                          _controller.value = v;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Higher frame rate'),
                    const SizedBox(height: 8),
                    Center(
                      child: Lottie.network(
                        _exampleSets[_selectedSetKey]!.highFpsUrl,
                        frameRate: FrameRate.max,
                        height: 180,
                        repeat: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Modify properties at runtime (delegates, network)',
                    ),
                    const SizedBox(height: 8),
                    DelegatesDemo(
                      url: _exampleSets[_selectedSetKey]!.delegatesUrl,
                    ),
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

class DelegatesDemo extends StatefulWidget {
  final String url;
  const DelegatesDemo({super.key, required this.url});

  @override
  State<DelegatesDemo> createState() => _DelegatesDemoState();
}

class _DelegatesDemoState extends State<DelegatesDemo>
    with TickerProviderStateMixin {
  late final Future<LottieComposition> _composition;
  AnimationController? _controller;
  bool _loop = true;

  @override
  void initState() {
    super.initState();
    _composition = NetworkLottie(widget.url).load();
  }

  @override
  void didUpdateWidget(covariant DelegatesDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      setState(() {
        _controller
          ?..stop()
          ..value = 0.0;
        _composition = NetworkLottie(widget.url).load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LottieComposition>(
      future: _composition,
      builder: (context, snapshot) {
        final composition = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || composition == null) {
          return const SizedBox(
            height: 180,
            child: Center(child: Text('Failed to load animation')),
          );
        }
        _controller ??= AnimationController(vsync: this);
        _controller!.duration = composition.duration;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Lottie(
                composition: composition,
                controller: _controller,
                delegates: LottieDelegates(
                  text: (initialText) => '**$initialText**',
                  values: [
                    ValueDelegate.color(const [
                      'Shape Layer 1',
                      'Rectangle',
                      'Fill 1',
                    ], value: Colors.red),
                    ValueDelegate.opacity(
                      const ['Shape Layer 1', 'Rectangle'],
                      callback: (frameInfo) =>
                          (frameInfo.overallProgress * 100).round(),
                    ),
                    ValueDelegate.position(const [
                      'Shape Layer 1',
                      'Rectangle',
                      '**',
                    ], relative: const Offset(100, 200)),
                  ],
                ),
                height: 180,
              ),
            ),
            const SizedBox(height: 8),
            _Controls(
              isLooping: _loop,
              isAnimating: _controller!.isAnimating,
              progress: _controller!.value,
              onPlay: () {
                if (_loop) {
                  _controller!.repeat();
                } else {
                  _controller!.forward();
                }
              },
              onPause: _controller!.stop,
              onReset: () {
                _controller!
                  ..stop()
                  ..value = 0.0;
              },
              onToggleLoop: (v) {
                setState(() {
                  _loop = v;
                });
                if (_controller!.isAnimating) {
                  if (v) {
                    _controller!.repeat();
                  } else {
                    _controller!.stop();
                  }
                }
              },
              onScrub: (v) {
                setState(() {
                  _controller!.value = v;
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class _Controls extends StatelessWidget {
  final bool isLooping;
  final bool isAnimating;
  final double progress;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final ValueChanged<bool> onToggleLoop;
  final ValueChanged<double> onScrub;

  const _Controls({
    required this.isLooping,
    required this.isAnimating,
    required this.progress,
    required this.onPlay,
    required this.onPause,
    required this.onReset,
    required this.onToggleLoop,
    required this.onScrub,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: isAnimating ? onPause : onPlay,
              icon: Icon(isAnimating ? Icons.pause : Icons.play_arrow),
              label: Text(isAnimating ? 'Pause' : 'Play'),
            ),
            ElevatedButton(onPressed: onReset, child: const Text('Reset')),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Loop'),
                Switch(value: isLooping, onChanged: onToggleLoop),
              ],
            ),
          ],
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 360;
            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Progress'),
                  Slider(
                    value: progress.clamp(0.0, 1.0),
                    onChanged: isLooping ? null : onScrub,
                  ),
                ],
              );
            }
            return Row(
              children: [
                const Text('Progress'),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: progress.clamp(0.0, 1.0),
                    onChanged: isLooping ? null : onScrub,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
