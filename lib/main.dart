import 'package:demo/features/service/graphql.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'core/graphql_config.dart';
import 'features/model/user.dart';
import 'features/view/home.dart';
import 'features/view/widget/editBottomSheetWidget.dart';

void main() {
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: HttpLink('http://localhost:5000/graphql?'),
      // The default store is the InMemoryStore, which does NOT persist to disk
      cache: GraphQLCache(),
    ),
  );
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.client});

  final ValueNotifier<GraphQLClient> client;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(
          title: "All Users",
        ),
      ),
    );
  }
}

class DummyUI extends StatefulWidget {
  const DummyUI({super.key});

  @override
  State<DummyUI> createState() => _DummyUIState();
}

class _DummyUIState extends State<DummyUI> {
  GraphQLService graphQLService = GraphQLService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
        options: QueryOptions(
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          document: gql("""
            query{ getAllUsers{ id email firstName lastName password } }
      """),
          variables: const {},
        ),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.isLoading) {
            return const CircularProgressIndicator();
          }

          if (result.hasException) {
            return Text("Something went wrong");
          }
          List<User> user = [];
          for (var i in result.data?['getAllUsers']) {
            user.add(User.fromJson(i));
          }
          return ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title:
                      Text("${user[index].firstName} ${user[index].lastName}"),
                  subtitle: Text(user[index].email ?? "N"),
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
                                      id: user[index].id ?? 0,
                                      fName: user[index].firstName ?? '',
                                      lName: user[index].lastName ?? "",
                                      email: user[index].email ?? "",
                                    );
                                  });
                              setState(() {});
                            },
                            child: Icon(
                              Icons.edit,
                              color: Colors.orange,
                            )),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              await graphQLService.deleteUser(
                                  id: user[index].id ?? 0);
                              setState(() {});
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
