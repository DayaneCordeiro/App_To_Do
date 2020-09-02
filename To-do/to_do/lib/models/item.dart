class Item {
  String title;
  bool done;

  /// @brief Constructs a Item
  Item({this.title, this.done});

  /// @brief Converts a Item into  JSON
  Item.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  /// @brief Converts a JSON into Item
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['title'] = this.title;
    data['done'] = this.done;

    return data;
  }
}
