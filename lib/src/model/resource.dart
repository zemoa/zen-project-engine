import 'package:equatable/equatable.dart';

class Resource extends Equatable {
  String _name;
  int _load;
  Resource(this._name, this._load);
  String get name {
    return _name;
  }
  int get load {
    return _load;
  }

  @override
  List<Object?> get props => [_name, _load];
}