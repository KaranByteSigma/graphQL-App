import 'package:demo/features/service/graphql.dart';
import 'package:demo/features/view/widget/addBottomSheetWidget.dart';
import 'package:demo/features/view/widget/editBottomSheetWidget.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GraphQLService graphQLService = GraphQLService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
          child: FutureBuilder(
            future: graphQLService.getAllUser(),
            builder: (context, snap) {
              if (snap.hasData && snap.data != null) {
                return ListView.builder(
                    itemCount: snap.data?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                            "${snap.data?[index].firstName} ${snap.data?[index].lastName}"),
                        subtitle: Text(snap.data?[index].email ?? "N"),
                        trailing: SizedBox(
                          width: 200,
                          height: 40,
                          child: Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    await showModalBottomSheet<void>(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return EditBottomSheetWidget(
                                            id:snap.data?[index].id ??0,
                                            fName:
                                            snap.data?[index].firstName ?? '',
                                            lName: snap.data?[index].lastName ?? "",
                                            email: snap.data?[index].email ?? "",
                                          );
                                        });
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await graphQLService.deleteUser(
                                        id: snap.data?[index].id ?? 0);
                                    setState(() {});
                                  },
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      );
                    });
              }
              return const Text("Loading");
            },
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          await showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return AddBottomSheetWidget();
              });
          setState(() {});
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}