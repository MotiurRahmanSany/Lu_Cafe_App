import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_cafe/features/search/presentation/search_controller.dart';

import '../../../core/common/constants/route_const.dart';
import '../../home/domain/food.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _focusNode = FocusNode();
  final _controller = TextEditingController();
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Food 🍔'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              focusNode: _focusNode,
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Search here...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (query) {
                ref
                    .read(searchControllerProvider.notifier)
                    .searchFoodByQuery(query);
              },
            ),
          ),
          searchState.when(
            data: (foods) {
              if (foods == null) {
                return _buildMessage('Search food you Love! 🍽️');
              } else if (foods.isEmpty) {
                return _buildMessage(
                  _controller.text.isEmpty
                      ? 'Search food you Love!'
                      : 'No food found',
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: foods.length,
                  itemBuilder: (context, index) {
                    final food = foods[index];
                    return _buildSearchResultTile(context, food: food);
                  },
                ),
              );
            },
            loading: () => Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
            error: (error, _) => _buildMessage('Error: $error'),
          )
        ],
      ),
    );
  }

  Widget _buildMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildSearchResultTile(BuildContext context, {required Food food}) {
    return Card(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(food.image),
        ),
        title: Text(food.name),
        subtitle: Text('৳ ${food.price.toStringAsFixed(0)}'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigating to food details screen
          context.pushNamed(
            RouteLocName.foodDetails,
            pathParameters: {'id': food.id},
          );
        },
      ),
    );
  }
}
