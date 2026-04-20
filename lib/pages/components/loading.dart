import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key, this.color});

  final Color? color;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late final AnimationController _loadingController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SpinKitDoubleBounce(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            size: 60,
          ),
          SpinKitPulse(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            size: 40,
          ),
          SpinKitRing(
            color: Theme.of(context).colorScheme.primary,
            size: 30,
            lineWidth: 2,
          ),
        ],
      ),
    );
  }
}
