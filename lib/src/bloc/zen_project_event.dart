import 'dart:ffi';

import 'package:equatable/equatable.dart';

abstract class ZenProjectEvent extends Equatable {}

class ZenProjectAddProject extends ZenProjectEvent {
  ZenProjectAddProject(this.startDate);
  final DateTime startDate;
  @override
  List<Object?> get props => [startDate];
}

class ZenProjectAddTaskEvent extends ZenProjectEvent {
  ZenProjectAddTaskEvent(this.name, this.duration, {this.previousTask});
  final String name;
  final double duration;
  final String? previousTask;
  @override
  List<Object?> get props => [name, duration, previousTask];
}