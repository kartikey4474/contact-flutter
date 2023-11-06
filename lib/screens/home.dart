import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_todo/constants.dart';
import 'package:flutter_bloc_todo/contact_bloc/contact_bloc.dart';
import 'package:flutter_bloc_todo/data/contact.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();

  TextEditingController controller4 = TextEditingController();
  addContact(Contact contact) {
    context.read<ContactBloc>().add(
          AddContact(contact),
        );
  }

  removeContact(Contact contact) {
    context.read<ContactBloc>().add(
          RemoveContact(contact),
        );
  }

  alertContact(int index) {
    context.read<ContactBloc>().add(AlterContact(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Add a Contact'),
                    content: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTextField(controller1, Icons.person, "Name"),
                        const SizedBox(height: 16),
                        _buildTextField(controller2, Icons.phone, "Phone"),
                        const SizedBox(height: 16),
                        _buildTextField(controller3, Icons.email, "Email"),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildTextField(
                            controller4, Icons.add_location, "Address"),
                        _addButton(),
                      ],
                    ),
                  );
                });
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.black,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/gradient1.png',
                height: 320,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
                child: BlocBuilder<ContactBloc, ContactState>(
                  builder: (context, state) {
                    if (state.status == ContactStatus.success) {
                      return ListView.builder(
                          itemCount: state.contacts.length,
                          itemBuilder: (context, int i) {
                            return Card(
                              color: Theme.of(context).colorScheme.primary,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Slidable(
                                key: const ValueKey(0),
                                startActionPane: ActionPane(
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (_) {
                                        removeContact(state.contacts[i]);
                                      },
                                      backgroundColor: const Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 60.0,
                                          height: 60.0,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/user.png"),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                state.contacts[i].name,
                                                style: const TextStyle(
                                                    fontSize: 22.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                state.contacts[i].email,
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                              ),
                                              Text(
                                                state.contacts[i].phone,
                                                style: const TextStyle(
                                                    fontSize: 16.0),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else if (state.status == ContactStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String hint) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.secondary,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon, // username
          color: Palette.iconColor,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.textColor1),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Palette.textColor1),
          borderRadius: BorderRadius.all(Radius.circular(35.0)),
        ),
        contentPadding: const EdgeInsets.all(10),
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: Palette.textColor1),
      ),
    );
  }

  Widget _addButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextButton(
        onPressed: () {
          addContact(
            Contact(
              name: controller1.text,
              phone: controller3.text,
              email: controller2.text,
              address: controller4.text,
            ),
          );
          Navigator.pop(context);

          FirebaseFirestore.instance.collection('contacts').add({
            'name': controller1.text,
            'phone': controller3.text,
            'email': controller2.text,
            'address': controller4.text,
          }).then((value) {
            // Handle success
            print("Data added to Firestore");
            controller1.clear();
            controller2.clear();
            controller3.clear();
            controller4.clear();
          }).catchError((error) {
            // Handle error
            print("Failed to add data: $error");
          });
        },
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Palette.kOrangeColor,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Palette.kOrangeColor,
        ),
        child: const Text("Add to contacts"),
      ),
    );
  }
}
