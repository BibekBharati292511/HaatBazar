class ProductFilterOptions {
  String? harvestedSeason;
  double? minPrice;
  double? maxPrice;
  double? minQty;
  double? maxQty;
  String? category;
  String? subCategory;

  ProductFilterOptions({
    this.harvestedSeason,
    this.minPrice,
    this.maxPrice,
    this.minQty,
    this.maxQty,
    this.category,
    this.subCategory,
  });
  @override
  String toString() {
    return 'ProductFilterOptions('
        'minPrice: $minPrice, '
        'maxPrice: $maxPrice, '
        'category: $category, '
        'subCategory: $subCategory, '
        'harvestedSeason: $harvestedSeason, '
        'minQty: $minQty, '
        'maxQty: $maxQty'
        ')';
  }
}

