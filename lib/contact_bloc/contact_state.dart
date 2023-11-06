part of 'contact_bloc.dart';

enum ContactStatus { initial, loading, success, error, failure }

class ContactState extends Equatable {
  final List<Contact> contacts;
  final ContactStatus status;

  const ContactState(
      {this.contacts = const <Contact>[], this.status = ContactStatus.initial});

  ContactState copyWith({
    ContactStatus? status,
    List<Contact>? todos,
  }) {
    return ContactState(
      contacts: todos ?? this.contacts,
      status: status ?? this.status,
    );
  }

  @override
  factory ContactState.fromJson(Map<String, dynamic> json) {
    try {
      var listOfContacts = (json['contact'] as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList();

      return ContactState(
          contacts: listOfContacts,
          status: ContactStatus.values.firstWhere(
              (element) => element.name.toString() == json['status']));
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {'contact': contacts, 'status': status.name};
  }

  @override
  List<Object?> get props => [contacts, status];
}
