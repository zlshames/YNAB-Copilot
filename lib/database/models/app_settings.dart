import 'package:objectbox/objectbox.dart';

enum ValueType { string, int, bool, double }

@Entity()
class AppSettings {
  @Id()
  int obxId = 0; // Let ObjectBox assign the ID

  @Unique(onConflict: ConflictStrategy.replace)
  String name;

  @Transient()
  dynamic value;

  String get dbValue {
    switch (type) {
      case ValueType.string:
        return value as String;
      case ValueType.int:
        return (value as int).toString();
      case ValueType.bool:
        return (value as bool).toString();
      case ValueType.double:
        return (value as double).toString();
      default:
        return value as String;
    }
  }

  set dbValue(dynamic value) {
    if (value is String) {
      this.value = value;
      dbType = ValueType.string.index;
    } else if (value is int) {
      this.value = value;
      dbType = ValueType.int.index;
    } else if (value is bool) {
      this.value = value;
      dbType = ValueType.bool.index;
    } else if (value is double) {
      this.value = value;
      dbType = ValueType.double.index;
    } else {
      this.value = value;
      dbType = ValueType.string.index;
    }
  }

  @Transient()
  ValueType? type;

  // ...and define a field with a supported type,
  // that is backed by the role field.
  int? get dbType {
    return type?.index;
  }

  set dbType(int? value) {
    if (value == null) {
      type = ValueType.string;
    } else {
      type = value >= 0 && value < ValueType.values.length ? ValueType.values[value] : ValueType.string;
    }
  }

  AppSettings({
    required this.name,
    dynamic value,
  }) {
    dbValue = value;
  }
}
