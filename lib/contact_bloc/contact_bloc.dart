import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_todo/data/contact.dart';
import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(const ContactState()) {
    on<ContactStarted>(_onStarted);
    on<AddContact>(_onAddContact);
    on<RemoveContact>(_onRemoveContact);
    on<AlterContact>(_onAlterContact);
  }

  void _onStarted(
    ContactStarted event,
    Emitter<ContactState> emit,
  ) {
    if (state.status == ContactStatus.success) return;
    emit(state.copyWith(todos: state.contacts, status: ContactStatus.success));
  }

  void _onAddContact(
    AddContact event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(status: ContactStatus.loading));
    try {
      List<Contact> temp = [];
      temp.addAll(state.contacts);
      temp.insert(0, event.contact);
      emit(state.copyWith(todos: temp, status: ContactStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ContactStatus.error));
    }
  }

  void _onRemoveContact(
    RemoveContact event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(status: ContactStatus.loading));
    try {
      state.contacts.remove(event.contact);
      emit(
          state.copyWith(todos: state.contacts, status: ContactStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ContactStatus.error));
    }
  }

  void _onAlterContact(
    AlterContact event,
    Emitter<ContactState> emit,
  ) {
    emit(state.copyWith(status: ContactStatus.loading));
    try {
      emit(
          state.copyWith(todos: state.contacts, status: ContactStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ContactStatus.error));
    }
  }

  Stream<ContactState> _mapAddContactToState(AddContact event) async* {
    try {
      // Add logic here to post data to Firestore server
      await FirebaseFirestore.instance
          .collection('contacts')
          .add(event.contact.toMap());
      yield state.copyWith(
        todos: List.from(state.contacts)..add(event.contact),
        status: ContactStatus.success,
      );
    } catch (_) {
      yield state.copyWith(status: ContactStatus.failure);
    }
  }
}
