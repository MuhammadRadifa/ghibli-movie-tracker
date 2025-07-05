import 'package:flutter/material.dart';
import 'package:ghibli_movies/layers/data/constant/app_color.dart';

class BottomBarAppContent extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final List<Widget Function()> pageBuilders;

  const BottomBarAppContent({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.pageBuilders,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 32,
                  color: selectedIndex == 0 ? AppColors.primary : Colors.grey,
                ),
                onPressed: () => onItemTapped(0),
              ),
              Container(
                height: 3,
                width: 24,
                decoration: BoxDecoration(
                  color: selectedIndex == 0
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.bar_chart,
                  size: 32,
                  color: selectedIndex == 1 ? AppColors.primary : Colors.grey,
                ),
                onPressed: () => onItemTapped(1),
              ),
              Container(
                height: 3,
                width: 24,
                decoration: BoxDecoration(
                  color: selectedIndex == 1
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const Spacer(flex: 4),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  size: 32,
                  color: selectedIndex == 2 ? AppColors.primary : Colors.grey,
                ),
                onPressed: () => onItemTapped(2),
              ),
              Container(
                height: 3,
                width: 24,
                decoration: BoxDecoration(
                  color: selectedIndex == 2
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu_book_sharp,
                  size: 32,
                  color: selectedIndex == 3 ? AppColors.primary : Colors.grey,
                ),
                onPressed: () => onItemTapped(3),
              ),
              Container(
                height: 3,
                width: 24,
                decoration: BoxDecoration(
                  color: selectedIndex == 3
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
