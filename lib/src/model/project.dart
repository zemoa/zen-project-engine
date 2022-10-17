import 'package:equatable/equatable.dart';

class Project extends Equatable {
  Project(this.startDate);
  final DateTime startDate;
  @override
  List<Object?> get props => [startDate];
}