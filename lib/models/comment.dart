class Comments {
  final String message;
  final DateTime createdAt;
  Comments(this.message) : createdAt = DateTime.now();

  @override
  String toString() {
    return createdAt.toString();
  }
}
