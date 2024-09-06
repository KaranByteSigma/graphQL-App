import 'package:demo/features/service/graphql.dart';
import 'package:flutter/material.dart';

class EditBottomSheetWidget extends StatefulWidget {
  EditBottomSheetWidget(
      {super.key,
        required this.fName,
        required this.lName,
        required this.email,
        required this.id});

  String fName;
  String lName;
  String email;
  int id;

  @override
  State<EditBottomSheetWidget> createState() => _EditBottomSheetWidgetState();
}

class _EditBottomSheetWidgetState extends State<EditBottomSheetWidget> {
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GraphQLService graphQLService = GraphQLService();

  @override
  void initState() {
    fNameController = TextEditingController(text: widget.fName);
    lNameController = TextEditingController(text: widget.lName);
    emailController = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: fNameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                label: Text("First Name")),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: lNameController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                label: Text("Last Name")),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                label: Text("Email")),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                await graphQLService.editUser(
                    id: widget.id,
                    firstName: fNameController.text,
                    lastName: lNameController.text,
                    email: emailController.text);
                Navigator.pop(context);
              },
              child: Text("Submit"))
        ],
      ),
    );
  }
}