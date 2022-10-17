import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Task extends Equatable {
  final String id;
  final String name;
  final double duration;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> previousId;
  Task(this.id, this.name, this.duration, this.startDate, this.endDate, {this.previousId = const []});
  
  @override
  List<Object?> get props => [id, name, duration, startDate, endDate];
}