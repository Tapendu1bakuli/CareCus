import 'parents/model.dart';

class Currency extends Model {
  String id;
  int decimalDigits;
  int rounding;
  int countryId;
  String name;
  String symbol;
  String createdAt;
  String updatedAt;
  String code;
  List customFields;
  String nameSymbol;

  Currency(
      {this.id,
      this.decimalDigits,
      this.rounding,
      this.countryId,
      this.name,
      this.symbol,
      this.createdAt,
      this.updatedAt,
      this.code,
      this.customFields,
      this.nameSymbol});

  Currency.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    name = stringFromJson(json, "name");
    decimalDigits = intFromJson(json, "decimal_digits");
    rounding = intFromJson(json, "rounding");
    countryId = intFromJson(json, "country_id");
    symbol = transStringFromJson(json, "symbol");
    createdAt = stringFromJson(json, "created_at");
    updatedAt = stringFromJson(json, "updated_at");
    code = stringFromJson(json, "code");
    nameSymbol = stringFromJson(json, "name_symbol");
    customFields = listFromJson(json, "custom_fields", (v) => v);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    return data;
  }
}
