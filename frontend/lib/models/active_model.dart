class ActiveModel {
  String? name;
  num? queued;
  num? eta;
  num? count;
  ActiveModel({this.name, this.queued, this.eta, this.count});

  @override
  String toString() {
    return "$name ($count)";
  }
}
