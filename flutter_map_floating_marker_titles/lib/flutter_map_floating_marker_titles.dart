library flutter_map_floating_marker_titles;

import 'package:flutter/widgets.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/fmto_controller.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_czr_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/controller/map_view_interface/abstract_map_view_interface.dart';
import 'package:flutter_floating_map_marker_titles_core/model/floating_marker_title_info.dart';
import 'package:flutter_floating_map_marker_titles_core/view/abstract_map_view_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

part 'flutter_map_controller.dart';

class FlutterMapWithFMTO extends AbstractMapViewWrapper<_FlutterMapMVI> {
  final MapOptions _mapOptions;
  final List<Widget> _children;
  final List<Widget> _nonRotatedChildren;

  factory FlutterMapWithFMTO({
    required final FMTOOptions fmtoOptions,
    required final MapOptions options,
    final Key? key,
    final List<FloatingMarkerTitleInfo>? floatingTitles,
    final Stream<List<FloatingMarkerTitleInfo>>? floatingTitlesStream,
    final List<Widget> children = const [],
    final List<Widget> nonRotatedChildren = const [],
    final FMTOMapController? mapController,
  }) {
    return FlutterMapWithFMTO._internal(
      _FlutterMapMVI(mapController ?? FMTOMapController(), fmtoOptions.mapProjectionsCacheSize),
      fmtoOptions,
      key,
      options,
      children,
      nonRotatedChildren,
      floatingTitles: floatingTitles,
      floatingTitlesStream: floatingTitlesStream,
    );
  }

  FlutterMapWithFMTO._internal(
    final _FlutterMapMVI mapViewInterface,
    final FMTOOptions fmtoOptions,
    final Key? key,
    this._mapOptions,
    this._children,
    this._nonRotatedChildren, {
    final List<FloatingMarkerTitleInfo>? floatingTitles,
    final Stream<List<FloatingMarkerTitleInfo>>? floatingTitlesStream,
  }) : super(
          mapViewInterface,
          fmtoOptions,
          key: key,
          floatingTitles: floatingTitles,
          floatingTitlesStream: floatingTitlesStream,
        );

  @override
  Widget buildMapView(final BuildContext context, final _FlutterMapMVI mapViewInterface) {
    return FlutterMap(
      options: _mapOptions,
      children: _children,
      nonRotatedChildren: _nonRotatedChildren,
      mapController: mapViewInterface.mapController,
    );
  }
}

class FMTOMapController extends _MapControllerImpl {
  FlutterMapState? _fmtoMapControllerState;

  @override
  set state(final FlutterMapState state) {
    _fmtoMapControllerState = state;
    super.state = state;
  }

  double get rotation => _fmtoMapControllerState?.rotation ?? 0;
}

class _FlutterMapMVI extends AbstractCZRMapViewInterface {
  FMTOMapController mapController;

  _FlutterMapMVI(
    this.mapController,
    final int projCacheSize,
  ) : super(projCacheSize);

  @override
  void updateFrom(final AbstractMapViewInterface oldMapInterface) {
    super.updateFrom(oldMapInterface);
    if (oldMapInterface is _FlutterMapMVI) {
      mapController = oldMapInterface.mapController;
    }
  }

  @override
  LatLng getMapViewCenter() {
    return mapController.center;
  }

  @override
  double getMapViewZoom() {
    return mapController.zoom;
  }

  @override
  double getMapViewRotationDegrees() {
    return mapController.rotation;
  }
}
