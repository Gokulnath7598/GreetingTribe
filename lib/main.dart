import 'package:flutter/material.dart';
import 'dart:async';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ARKitController arkitController;

  Timer? timer;

  bool anchorWasFound = false;

  @override
  void dispose() {
    timer?.cancel();
    arkitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
            title: const Text('Greeting Tribe')),
        body: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ARKitSceneView(
                detectionImagesGroupName: 'AR Resources',
                onARKitViewCreated: onARKitViewCreated,
              ),
              anchorWasFound
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Point the camera at the tribe image when you search tribe in Google.',
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      );

  void onARKitViewCreated(ARKitController arkitController) {
    this.arkitController = arkitController;
    this.arkitController.onAddNodeForAnchor = onAnchorWasFound;
  }

  void onAnchorWasFound(ARKitAnchor anchor) {
    if (anchor is ARKitImageAnchor) {
      setState(() => anchorWasFound = true);
      final earthPosition = anchor.transform.getColumn(3);
      final node = ARKitReferenceNode(
        url: 'models.scnassets/tribe/tribe.dae',
        position:
            vector.Vector3(earthPosition.x, earthPosition.y, earthPosition.z),
        scale: vector.Vector3(0.002, 0.002, 0.002),
      );
      arkitController.add(node);
      // arkitController.playAnimation(
      //     key: 'dancing',
      //     sceneName: 'models.scnassets/remy_dancing',
      //     animationIdentifier: 'remy_dancing-1');
      // timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      //   arkitController.playAnimation(
      //       key: 'dancing',
      //       sceneName: 'models.scnassets/remy_dancing',
      //       animationIdentifier: 'remy_dancing-1');
      // });
    }
  }
}
