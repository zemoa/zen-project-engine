import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:zen_project_engine/src/bloc/zen_project_event.dart';
import 'package:zen_project_engine/src/bloc/zen_project_state.dart';
import 'package:zen_project_engine/src/model/project.dart';
import 'package:zen_project_engine/src/model/task.dart';


class ZenProjectBloc extends Bloc<ZenProjectEvent, ZenProjectState> {
  Uuid _idGenerator;
  ZenProjectBloc(this._idGenerator): super(ZenProjectState()) {
    on<ZenProjectAddProject>(_onAddProject);
    on<ZenProjectAddTaskEvent>(_onAddTask);
  }
  
  Future<void> _onAddTask(ZenProjectAddTaskEvent event, Emitter<ZenProjectState> emit) async {
    if(state.project != null) {
      Task newTask;
      if(event.previousTask != null) {
        Task? previousTask = state.taskList?.firstWhere((element) => element.id == event.previousTask);
        if(previousTask != null) {
          var startDate = previousTask.endDate.add(Duration(days: 1));
          newTask = Task(_idGenerator.v4(), event.name, event.duration, startDate, startDate.add(Duration(days: event.duration.toInt())));
        } else {
          newTask = Task(_idGenerator.v4(), event.name, event.duration, state.project!.startDate, state.project!.startDate.add(Duration(days: event.duration.toInt())));
        }
      } else {
        newTask = Task(_idGenerator.v4(), event.name, event.duration, state.project!.startDate, state.project!.startDate.add(Duration(days: event.duration.toInt())));
      }
      emit(state.copyWith(taskList: [...state.taskList!, newTask]));
    }
  }

  Future<void> _onAddProject(ZenProjectAddProject event, Emitter<ZenProjectState> emit) async {
    emit(state.copyWith(project: Project(event.startDate), resourceList: [], taskList: []));
  }
}