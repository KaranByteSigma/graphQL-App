
import 'package:demo/features/service/graphql.dart';
import 'package:flutter/material.dart';

class AddBottomSheetWidget extends StatelessWidget {
  AddBottomSheetWidget({super.key});

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  GraphQLService graphQLService = GraphQLService();

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
                await graphQLService.addUser(
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