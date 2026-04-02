import 'package:flutter/material.dart';
import 'package:swiftcare/services/api_service.dart';
import 'package:swiftcare/services/shared_resource.dart';
import 'package:uicons/uicons.dart';

class FavoriteHeart extends StatelessWidget {
  final String doctorId;
  const FavoriteHeart({super.key, required this.doctorId});

  Future<void> _toggleFavorite(bool currentlyFav) async {
    // Optimistic update — all FavoriteHeart widgets on screen rebuild instantly
    final updated = List<String>.from(SharedResources.favorites.value);
    if (currentlyFav) {
      updated.remove(doctorId);
    } else {
      updated.add(doctorId);
    }
    SharedResources.favorites.value = updated;

    // Persist to DB + refresh from server (confirms the truth)
    await ApiService().toggleFavorite(
      SharedResources.userData.value['_id'],
      doctorId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: SharedResources.favorites,
      builder: (context, favs, _) {
        final isFav = favs.contains(doctorId);
        return GestureDetector(
          onTap: () => _toggleFavorite(isFav),
          child: Icon(
            isFav ? UIcons.solidRounded.heart : UIcons.regularRounded.heart,
            color: isFav ? Colors.red : Colors.grey,
          ),
        );
      },
    );
  }
}
