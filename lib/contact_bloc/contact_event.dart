part of 'contact_bloc.dart';

@immutable
abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

class ContactStarted extends ContactEvent {}

class AddContact extends ContactEvent {
  final Contact contact;

  const AddContact(this.contact);

  @override
  List<Object?> get props => [contact];
}

class RemoveContact extends ContactEvent {
  final Contact contact;

  const RemoveContact(this.contact);

  @override
  List<Object?> get props => [contact];
}

class AlterContact extends ContactEvent {
  final int index;

  const AlterContact(this.index);

  @override
  List<Object?> get props => [index];
}
