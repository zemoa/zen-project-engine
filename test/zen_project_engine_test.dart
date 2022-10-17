import 'package:bloc_test/bloc_test.dart';
import 'package:test/fake.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';
import 'package:zen_project_engine/src/bloc/zen_project_bloc.dart';
import 'package:zen_project_engine/src/bloc/zen_project_event.dart';
import 'package:zen_project_engine/src/bloc/zen_project_state.dart';
import 'package:zen_project_engine/src/model/project.dart';
import 'package:zen_project_engine/src/model/task.dart';

// Fake class
class FakeUuid extends Fake implements Uuid {
  int _iteration = 0;
  List<String> generatedUuid = [];
  FakeUuid() {
    for(int i = 0; i < 100; i++) {
      generatedUuid.add(Uuid().v4());
    }
  }
  @override
   String v4({Map<String, dynamic>? options}) { 
    String result = generatedUuid[_iteration];
    _iteration++;
    return result;
   }

   void reset() {
    _iteration = 0;
   }
}

void main() {
  group('ProjectBloc', () {
    late ZenProjectBloc zenProjectBloc;
    FakeUuid fakeUuid = FakeUuid();
    setUp(() {
      zenProjectBloc = ZenProjectBloc(fakeUuid);
    });

    test('Initale state', () {
      expect(zenProjectBloc.state.project, isNull);
      expect(zenProjectBloc.state.taskList, isNull);
      expect(zenProjectBloc.state.resourceList, isNull);
    });

    blocTest<ZenProjectBloc, ZenProjectState>(
      'Add project with start date 01/06/2022', 
      build: () => zenProjectBloc,
      act: (bloc) => bloc.add(ZenProjectAddProject(DateTime.parse("2022-06-01"))),
      expect: () => <ZenProjectState>[
        ZenProjectState(project: Project(DateTime.parse("2022-06-01")), resourceList: [], taskList: [])
      ]
    );

    blocTest<ZenProjectBloc, ZenProjectState>(
      'Add a task with duration of 5 days should end the 11/06/2022', 
      build: () => zenProjectBloc,
      seed: () => ZenProjectState(project: Project(DateTime.parse("2022-06-01")), resourceList: [], taskList: []),
      act: (bloc) => bloc.add(ZenProjectAddTaskEvent('Task 1', 5.0)),
      expect: () => [
        ZenProjectState(
          project: Project(DateTime.parse("2022-06-01")),
          taskList: [
            Task(fakeUuid.generatedUuid[0], 'Task 1', 5.0, DateTime.parse("2022-06-01"), DateTime.parse("2022-06-06"))
          ],
          resourceList: []
          )
      ]
    );
    blocTest<ZenProjectBloc, ZenProjectState>(
      'Add a second task with duration of 5 days depending on the first should end the 12/06/2022', 
      setUp: () => {
        fakeUuid.reset()
      },
      build: () => zenProjectBloc,
      seed: () => ZenProjectState(
          project: Project(DateTime.parse("2022-06-01")),
          taskList: [
            Task(fakeUuid.v4(), 'Task 1', 5.0, DateTime.parse("2022-06-01"), DateTime.parse("2022-06-06"))
          ],
          resourceList: []
        ),
      act: (bloc) => bloc.add(ZenProjectAddTaskEvent('Task 1', 5.0, previousTask: fakeUuid.generatedUuid[0])),
      expect: () => <ZenProjectState>[
        ZenProjectState(
          project: Project(DateTime.parse("2022-06-01")),
          taskList: [
            Task(fakeUuid.generatedUuid[0], 'Task 1', 5.0, DateTime.parse("2022-06-01"), DateTime.parse("2022-06-06")),
            Task(fakeUuid.generatedUuid[1], 'Task 1', 5.0, DateTime.parse("2022-06-07"), DateTime.parse("2022-06-12"), previousId: [fakeUuid.generatedUuid[0]])
          ],
          resourceList: []
        )
      ]
    );
  });
}
