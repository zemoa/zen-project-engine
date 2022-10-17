import 'package:equatable/equatable.dart';
import 'package:zen_project_engine/src/model/project.dart';
import 'package:zen_project_engine/src/model/resource.dart';
import 'package:zen_project_engine/src/model/task.dart';

class ZenProjectState extends Equatable {
  ZenProjectState({this.project, this.taskList, this.resourceList});
  final Project? project;
  final List<Task>? taskList;
  final List<Resource>? resourceList;

  ZenProjectState copyWith({
    Project? project,
    List<Task>? taskList,
    List<Resource>? resourceList,
  }) {
    return ZenProjectState(
      project: project ?? this.project,
      taskList: taskList ?? this.taskList,
      resourceList: resourceList ?? this.resourceList,
    );
  }

  @override
  List<Object?> get props => [project, taskList, resourceList];
}