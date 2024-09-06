import 'package:demo/core/graphql_config.dart';
import 'package:demo/features/model/user.dart';
import 'package:graphql/client.dart';

class GraphQLService {
  static GraphqlConfig graphqlConfig = GraphqlConfig();
  GraphQLClient graphQLClient = graphqlConfig.graphQLClient();

  Future<List<User>> getAllUser() async {
    try {
      List<User> user = [];
      QueryResult result =
          await graphQLClient.query(QueryOptions(document: gql("""
            query{ getAllUsers{ id email firstName lastName password } }
      """), fetchPolicy: FetchPolicy.noCache));
      for (var i in result.data?['getAllUsers']) {
        user.add(User.fromJson(i));
      }
      return user;
    } catch (e) {
      return [];
    }
  }

  Future<bool> deleteUser({required int id}) async {
    try {
      QueryResult res =
          await graphQLClient.mutate(MutationOptions(document: gql("""
      mutation {
  deleteUser(id: $id) {
    id
    firstName
    lastName
    email
  }
}
      """)));
      if (res.hasException) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> addUser(
      {required String firstName,
      required String lastName,
      required String email}) async {
    try {
      QueryResult res =
          await graphQLClient.mutate(MutationOptions(document: gql("""
      mutation {
  createUser( firstName: "$firstName", lastName: "$lastName", email: "$email") {
    
    firstName
    lastName
    email
  }
}
      """)));
      if (res.hasException) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editUser(
      {required int id,
      required String firstName,
      required String lastName,
      required String email}) async {
    try {
      QueryResult res =
          await graphQLClient.mutate(MutationOptions(document: gql("""
      mutation {
  editUser( id:$id,firstName: "$firstName", lastName: "$lastName", email: "$email") {
    id
    firstName
    lastName
    email
  }
}
      """)));
      if (res.hasException) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
