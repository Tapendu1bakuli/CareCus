import 'parents/model.dart';

class TimeZoneSlotModel extends Model{
  String text;
  dynamic slotId;
  bool isSelected;
  int index;
  TimeZoneSlotModel(this.text, this.slotId, this.isSelected,this.index);

  TimeZoneSlotModel.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    text = stringFromJson(json, 'text');
    isSelected = boolFromJson(json, 'isSelected');
    slotId = stringFromJson(json, 'id');
    index = intFromJson(json, 'index');
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['slotId'] = this.slotId;
    data['isSelected'] = this.isSelected;
    data['text'] = this.text;
    data['index'] = this.index;
    return data;
  }

}