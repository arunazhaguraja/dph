class SliderModel {
  String? name;
  String? image;
  int? productId;

  SliderModel({this.name, this.image,this.productId});
}

List<SliderModel> getSlides = [
    new SliderModel(name: "Parboiled Rice", image: "images/boiled_rice.jpg",productId: 1),
    new SliderModel(name: "Raw Rice", image: "images/raw_rice.jpg",productId: 2),
    new SliderModel(name: "Boiled Rice", image: "images/boiled_rice.jpg",productId: 3)
  ];

