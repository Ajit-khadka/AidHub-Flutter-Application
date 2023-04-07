import 'package:flutter/material.dart';
import '../../Login/verification/forgotpassword.dart';
import 'employee_list.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({super.key});

  static const id = 'set_photo_screen';

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

String? featureLen(value) {
  if (value!.isEmpty || !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
    return "Not a valid Feature";
  } else if (value.length < 3) {
    return "Minimum 3 letter";
  } else if (value.length > 20) {
    return "Maximum 20 letter";
  } else {
    return null;
  }
}

class _EmployeeListState extends State<EmployeeList> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  List<Contact> contacts = List.empty(growable: true);

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
        title: const Text(
          'Employee',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Add Employee",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Username
              Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: TextFormField(
                    controller: nameController,
                    onSaved: (value) {
                      contactController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                    validator: featureLen,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "Employee Name"),
                  )),
              const SizedBox(height: 15),
//Profession
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: TextFormField(
                  controller: contactController,
                  // initialValue: status,
                  onSaved: (value) {
                    contactController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  validator: featureLen,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.health_and_safety),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: "Department"),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          String name = nameController.text.trim();
                          String contact = contactController.text.trim();
                          if (name.isNotEmpty && contact.isNotEmpty) {
                            setState(() {
                              nameController.text = '';
                              contactController.text = '';
                              contacts
                                  .add(Contact(name: name, contact: contact));
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 0,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          String name = nameController.text.trim();
                          String contact = contactController.text.trim();
                          if (name.isNotEmpty && contact.isNotEmpty) {
                            setState(() {
                              nameController.text = '';
                              contactController.text = '';
                              contacts[selectedIndex].name = name;
                              contacts[selectedIndex].contact = contact;
                              selectedIndex = -1;
                            });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        backgroundColor: const Color.fromRGBO(254, 109, 115, 1),
                      ),
                      child: const Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Employee List",
                  style: TextStyle(
                    color: Color.fromARGB(255, 68, 68, 130),
                    fontSize: 20,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              contacts.isEmpty
                  ? const Text(
                      'Employees are not added',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 68, 68, 130)),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: contacts.length,
                        itemBuilder: (context, index) => getRow(index),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            contacts[index].name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contacts[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(contacts[index].contact),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  //
                  nameController.text = contacts[index].name;
                  contactController.text = contacts[index].contact;
                  setState(() {
                    selectedIndex = index;
                  });
                  //
                },
                child: const Icon(Icons.edit,
                    color: Color.fromRGBO(254, 109, 115, 1)),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: (() {
                  //
                  setState(() {
                    contacts.removeAt(index);
                  });
                  //
                }),
                child: const Icon(
                  Icons.delete,
                  color: Color.fromRGBO(254, 109, 115, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
