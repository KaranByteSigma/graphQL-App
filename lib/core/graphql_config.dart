import 'package:graphql/client.dart';

class GraphqlConfig {
  static HttpLink httpLink = HttpLink('http://localhost:5000/graphql?');

  GraphQLClient graphQLClient() =>
      GraphQLClient(link: httpLink, cache: GraphQLCache());
}
