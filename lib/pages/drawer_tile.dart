import 'package:appfef/models/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';//import do Watch


class DrawerTile extends StatelessWidget {
  const DrawerTile({this.iconData, this.title, this.page});

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {

     final int curPage = context.watch<PageManager>().page;

    return InkWell(
      onTap: () {
       context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                iconData,
                size: 32,
                color: curPage == page ? Colors.red : Colors.pink[50],
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16, 
                color: curPage == page ? Colors.red : Colors.black,
            )
            ),
          ],
        ),
      ),
    );
  }
}
