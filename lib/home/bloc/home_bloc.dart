import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pract_dos/models/todo_reminder.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // DIDIT: inicializar la box
  Box _reminderBox = Hive.box("ReminderBox");

  HomeBloc() : super(HomeInitialState());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is OnLoadRemindersEvent) {
      try {
        List<TodoRemainder> _existingReminders = _loadReminders();
        yield LoadedRemindersState(todosList: _existingReminders);
      } on DatabaseDoesNotExist catch (_) {
        yield NoRemindersState();
      } on EmptyDatabase catch (_) {
        yield NoRemindersState();
      }
    }
    if (event is OnAddElementEvent) {
      _saveTodoReminder(event.todoReminder);
      yield NewReminderState(todo: event.todoReminder);
    }
    if (event is OnReminderAddedEvent) {
      yield AwaitingEventsState();
    }
    if (event is OnRemoveElementEvent) {
      _removeTodoReminder(event.removedAtIndex);
    }
  }

  List<TodoRemainder> _loadReminders() {
    // DIDIT: ver si existen datos To-doRemainder en la box y sacarlos como Lista (no es necesario hacer get ni put)
    // debe haber un adapter para que la BD pueda detectar el objeto

    //TODO: Revisar si funciona
    if (_reminderBox.isNotEmpty) {
      return _reminderBox.values.map((e) => e as TodoRemainder).toList();
    }

    throw EmptyDatabase();
  }

  void _saveTodoReminder(TodoRemainder todoReminder) {
    // DIDIT:add item here
    _reminderBox.add(todoReminder);
  }

  void _removeTodoReminder(int removedAtIndex) {
    // DIDIT:delete item here
    _reminderBox.deleteAt(removedAtIndex);
  }
}

class DatabaseDoesNotExist implements Exception {}

class EmptyDatabase implements Exception {}
