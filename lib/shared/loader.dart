import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mentalease/colors.dart';


LoaderOverlay loader({required Widget child}) => LoaderOverlay(
    useDefaultLoading: false,
    overlayWidget: const Center(
      child: CircularProgressIndicator(color: cMain),
    ),
    overlayColor: cBlack.withOpacity(0.3),
    overlayOpacity: 1,
    child: child);
