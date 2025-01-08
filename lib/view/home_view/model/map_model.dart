class MapsModel {
  MapsModel({
    this.htmlAttributions,
    this.nextPageToken,
    this.results,
    this.status,
  });

  final List<dynamic>? htmlAttributions;
  final String? nextPageToken;
  final List<MapResult>? results;
  final String? status;

  factory MapsModel.fromJson(Map<String, dynamic> json){
    return MapsModel(
      htmlAttributions: json["html_attributions"] == null ? [] : List<dynamic>.from(json["html_attributions"]!.map((x) => x)),
      nextPageToken: json["next_page_token"],
      results: json["results"] == null ? [] : List<MapResult>.from(json["results"]!.map((x) => MapResult.fromJson(x))),
      status: json["status"],
    );
  }

}

class MapResult {
  MapResult({
    required this.geometry,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconMaskBaseUri,
    required this.name,
    required this.photos,
    required this.placeId,
    required this.reference,
    required this.scope,
    required this.types,
    required this.vicinity,
    required this.businessStatus,
    required this.openingHours,
    required this.rating,
    required this.userRatingsTotal,
    required this.plusCode,
    required this.priceLevel,
  });

  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String? name;
  final List<Photo> photos;
  final String? placeId;
  final String? reference;
  final String? scope;
  final List<String> types;
  final String? vicinity;
  final String? businessStatus;
  final OpeningHours? openingHours;
  final double? rating;
  final int? userRatingsTotal;
  final PlusCode? plusCode;
  final int? priceLevel;

  factory MapResult.fromJson(Map<String, dynamic> json){
    return MapResult(
      geometry: json["geometry"] == null ? null : Geometry.fromJson(json["geometry"]),
      icon: json["icon"],
      iconBackgroundColor: json["icon_background_color"],
      iconMaskBaseUri: json["icon_mask_base_uri"],
      name: json["name"],
      photos: json["photos"] == null ? [] : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
      placeId: json["place_id"],
      reference: json["reference"],
      scope: json["scope"],
      types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
      vicinity: json["vicinity"],
      businessStatus: json["business_status"],
      openingHours: json["opening_hours"] == null ? null : OpeningHours.fromJson(json["opening_hours"]),
      rating: json["rating"],
      userRatingsTotal: json["user_ratings_total"],
      plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
      priceLevel: json["price_level"],
    );
  }

}

class Geometry {
  Geometry({
    required this.location,
    required this.viewport,
  });

  final Location? location;
  final Viewport? viewport;

  factory Geometry.fromJson(Map<String, dynamic> json){
    return Geometry(
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      viewport: json["viewport"] == null ? null : Viewport.fromJson(json["viewport"]),
    );
  }

}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  final double? lat;
  final double? lng;

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      lat: json["lat"],
      lng: json["lng"],
    );
  }

}

class Viewport {
  Viewport({
    required this.northeast,
    required this.southwest,
  });

  final Location? northeast;
  final Location? southwest;

  factory Viewport.fromJson(Map<String, dynamic> json){
    return Viewport(
      northeast: json["northeast"] == null ? null : Location.fromJson(json["northeast"]),
      southwest: json["southwest"] == null ? null : Location.fromJson(json["southwest"]),
    );
  }

}

class OpeningHours {
  OpeningHours({
    required this.openNow,
  });

  final bool? openNow;

  factory OpeningHours.fromJson(Map<String, dynamic> json){
    return OpeningHours(
      openNow: json["open_now"],
    );
  }

}

class Photo {
  Photo({
    required this.height,
    required this.htmlAttributions,
    required this.photoReference,
    required this.width,
  });

  final int? height;
  final List<String> htmlAttributions;
  final String? photoReference;
  final int? width;

  factory Photo.fromJson(Map<String, dynamic> json){
    return Photo(
      height: json["height"],
      htmlAttributions: json["html_attributions"] == null ? [] : List<String>.from(json["html_attributions"]!.map((x) => x)),
      photoReference: json["photo_reference"],
      width: json["width"],
    );
  }

}

class PlusCode {
  PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  final String? compoundCode;
  final String? globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json){
    return PlusCode(
      compoundCode: json["compound_code"],
      globalCode: json["global_code"],
    );
  }

}
