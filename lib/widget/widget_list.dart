import 'package:flutter/material.dart';
import 'package:proyecto/model/user_model.dart';

class UserList extends StatefulWidget {
  final List<User> users;
  final Function(User) addUser;
  const UserList({
    Key? key,
    required this.users,
    required this.addUser,
  }) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: widget.users[index].photoUrl.isEmpty
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.users[index].color,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.users[index].displayName.characters.first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                )
              : Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.users[index].photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          title: Text(
            widget.users[index].displayName,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Text(
            widget.users[index].email,
            maxLines: 1,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          onTap: () {
            setState(() {
              widget.addUser(widget.users[index]);
              widget.users.remove(widget.users[index]);
            });
          },
          trailing: Icon(
            Icons.add,
            color: isDark ? Colors.white : Colors.black,
          ),
        );
      },
    );
  }
}

class UserListOnly extends StatefulWidget {
  final List<User> users;
  const UserListOnly({
    Key? key,
    required this.users,
  }) : super(key: key);

  @override
  State<UserListOnly> createState() => _UserListOnlyState();
}

class _UserListOnlyState extends State<UserListOnly> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).primaryColor == Colors.white;
    return ListView.builder(
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: widget.users[index].photoUrl.isEmpty
              ? Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.users[index].color,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.users[index].displayName.characters.first,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                )
              : Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.users[index].photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          title: Text(
            widget.users[index].displayName,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Text(
            widget.users[index].email,
            maxLines: 1,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        );
      },
    );
  }
}
