/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the MonthlyBrainSignalTable type in your schema. */
class MonthlyBrainSignalTable {
  final String id;
  final String? _month;
  final int? _total_time;
  final int? _avg_att;
  final int? _avg_med;
  final String? _firsts_name;
  final int? _first_amt;
  final String? _second_name;
  final int? _second_amt;
  final int? _con_score;
  final int? _spacetime_score;
  final int? _exec_score;
  final int? _mem_score;
  final int? _ling_score;
  final int? _cal_score;
  final int? _reac_score;
  final int? _orient_score;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  String get month {
    try {
      return _month!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int? get total_time {
    return _total_time;
  }
  
  int? get avg_att {
    return _avg_att;
  }
  
  int? get avg_med {
    return _avg_med;
  }
  
  String? get firsts_name {
    return _firsts_name;
  }
  
  int? get first_amt {
    return _first_amt;
  }
  
  String? get second_name {
    return _second_name;
  }
  
  int? get second_amt {
    return _second_amt;
  }
  
  int? get con_score {
    return _con_score;
  }
  
  int? get spacetime_score {
    return _spacetime_score;
  }
  
  int? get exec_score {
    return _exec_score;
  }
  
  int? get mem_score {
    return _mem_score;
  }
  
  int? get ling_score {
    return _ling_score;
  }
  
  int? get cal_score {
    return _cal_score;
  }
  
  int? get reac_score {
    return _reac_score;
  }
  
  int? get orient_score {
    return _orient_score;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const MonthlyBrainSignalTable._internal({required this.id, required month, total_time, avg_att, avg_med, firsts_name, first_amt, second_name, second_amt, con_score, spacetime_score, exec_score, mem_score, ling_score, cal_score, reac_score, orient_score, createdAt, updatedAt}): _month = month, _total_time = total_time, _avg_att = avg_att, _avg_med = avg_med, _firsts_name = firsts_name, _first_amt = first_amt, _second_name = second_name, _second_amt = second_amt, _con_score = con_score, _spacetime_score = spacetime_score, _exec_score = exec_score, _mem_score = mem_score, _ling_score = ling_score, _cal_score = cal_score, _reac_score = reac_score, _orient_score = orient_score, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory MonthlyBrainSignalTable({String? id, required String month, int? total_time, int? avg_att, int? avg_med, String? firsts_name, int? first_amt, String? second_name, int? second_amt, int? con_score, int? spacetime_score, int? exec_score, int? mem_score, int? ling_score, int? cal_score, int? reac_score, int? orient_score, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return MonthlyBrainSignalTable._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      month: month,
      total_time: total_time,
      avg_att: avg_att,
      avg_med: avg_med,
      firsts_name: firsts_name,
      first_amt: first_amt,
      second_name: second_name,
      second_amt: second_amt,
      con_score: con_score,
      spacetime_score: spacetime_score,
      exec_score: exec_score,
      mem_score: mem_score,
      ling_score: ling_score,
      cal_score: cal_score,
      reac_score: reac_score,
      orient_score: orient_score,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MonthlyBrainSignalTable &&
      id == other.id &&
      _month == other._month &&
      _total_time == other._total_time &&
      _avg_att == other._avg_att &&
      _avg_med == other._avg_med &&
      _firsts_name == other._firsts_name &&
      _first_amt == other._first_amt &&
      _second_name == other._second_name &&
      _second_amt == other._second_amt &&
      _con_score == other._con_score &&
      _spacetime_score == other._spacetime_score &&
      _exec_score == other._exec_score &&
      _mem_score == other._mem_score &&
      _ling_score == other._ling_score &&
      _cal_score == other._cal_score &&
      _reac_score == other._reac_score &&
      _orient_score == other._orient_score &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MonthlyBrainSignalTable {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("month=" + "$_month" + ", ");
    buffer.write("total_time=" + (_total_time != null ? _total_time!.toString() : "null") + ", ");
    buffer.write("avg_att=" + (_avg_att != null ? _avg_att!.toString() : "null") + ", ");
    buffer.write("avg_med=" + (_avg_med != null ? _avg_med!.toString() : "null") + ", ");
    buffer.write("firsts_name=" + "$_firsts_name" + ", ");
    buffer.write("first_amt=" + (_first_amt != null ? _first_amt!.toString() : "null") + ", ");
    buffer.write("second_name=" + "$_second_name" + ", ");
    buffer.write("second_amt=" + (_second_amt != null ? _second_amt!.toString() : "null") + ", ");
    buffer.write("con_score=" + (_con_score != null ? _con_score!.toString() : "null") + ", ");
    buffer.write("spacetime_score=" + (_spacetime_score != null ? _spacetime_score!.toString() : "null") + ", ");
    buffer.write("exec_score=" + (_exec_score != null ? _exec_score!.toString() : "null") + ", ");
    buffer.write("mem_score=" + (_mem_score != null ? _mem_score!.toString() : "null") + ", ");
    buffer.write("ling_score=" + (_ling_score != null ? _ling_score!.toString() : "null") + ", ");
    buffer.write("cal_score=" + (_cal_score != null ? _cal_score!.toString() : "null") + ", ");
    buffer.write("reac_score=" + (_reac_score != null ? _reac_score!.toString() : "null") + ", ");
    buffer.write("orient_score=" + (_orient_score != null ? _orient_score!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MonthlyBrainSignalTable copyWith({String? id, String? month, int? total_time, int? avg_att, int? avg_med, String? firsts_name, int? first_amt, String? second_name, int? second_amt, int? con_score, int? spacetime_score, int? exec_score, int? mem_score, int? ling_score, int? cal_score, int? reac_score, int? orient_score, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return MonthlyBrainSignalTable._internal(
      id: id ?? this.id,
      month: month ?? this.month,
      total_time: total_time ?? this.total_time,
      avg_att: avg_att ?? this.avg_att,
      avg_med: avg_med ?? this.avg_med,
      firsts_name: firsts_name ?? this.firsts_name,
      first_amt: first_amt ?? this.first_amt,
      second_name: second_name ?? this.second_name,
      second_amt: second_amt ?? this.second_amt,
      con_score: con_score ?? this.con_score,
      spacetime_score: spacetime_score ?? this.spacetime_score,
      exec_score: exec_score ?? this.exec_score,
      mem_score: mem_score ?? this.mem_score,
      ling_score: ling_score ?? this.ling_score,
      cal_score: cal_score ?? this.cal_score,
      reac_score: reac_score ?? this.reac_score,
      orient_score: orient_score ?? this.orient_score,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  MonthlyBrainSignalTable copyWithModelFieldValues({
    ModelFieldValue<String>? id,
    ModelFieldValue<String>? month,
    ModelFieldValue<int?>? total_time,
    ModelFieldValue<int?>? avg_att,
    ModelFieldValue<int?>? avg_med,
    ModelFieldValue<String?>? firsts_name,
    ModelFieldValue<int?>? first_amt,
    ModelFieldValue<String?>? second_name,
    ModelFieldValue<int?>? second_amt,
    ModelFieldValue<int?>? con_score,
    ModelFieldValue<int?>? spacetime_score,
    ModelFieldValue<int?>? exec_score,
    ModelFieldValue<int?>? mem_score,
    ModelFieldValue<int?>? ling_score,
    ModelFieldValue<int?>? cal_score,
    ModelFieldValue<int?>? reac_score,
    ModelFieldValue<int?>? orient_score,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return MonthlyBrainSignalTable._internal(
      id: id == null ? this.id : id.value,
      month: month == null ? this.month : month.value,
      total_time: total_time == null ? this.total_time : total_time.value,
      avg_att: avg_att == null ? this.avg_att : avg_att.value,
      avg_med: avg_med == null ? this.avg_med : avg_med.value,
      firsts_name: firsts_name == null ? this.firsts_name : firsts_name.value,
      first_amt: first_amt == null ? this.first_amt : first_amt.value,
      second_name: second_name == null ? this.second_name : second_name.value,
      second_amt: second_amt == null ? this.second_amt : second_amt.value,
      con_score: con_score == null ? this.con_score : con_score.value,
      spacetime_score: spacetime_score == null ? this.spacetime_score : spacetime_score.value,
      exec_score: exec_score == null ? this.exec_score : exec_score.value,
      mem_score: mem_score == null ? this.mem_score : mem_score.value,
      ling_score: ling_score == null ? this.ling_score : ling_score.value,
      cal_score: cal_score == null ? this.cal_score : cal_score.value,
      reac_score: reac_score == null ? this.reac_score : reac_score.value,
      orient_score: orient_score == null ? this.orient_score : orient_score.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  MonthlyBrainSignalTable.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _month = json['month'],
      _total_time = (json['total_time'] as num?)?.toInt(),
      _avg_att = (json['avg_att'] as num?)?.toInt(),
      _avg_med = (json['avg_med'] as num?)?.toInt(),
      _firsts_name = json['firsts_name'],
      _first_amt = (json['first_amt'] as num?)?.toInt(),
      _second_name = json['second_name'],
      _second_amt = (json['second_amt'] as num?)?.toInt(),
      _con_score = (json['con_score'] as num?)?.toInt(),
      _spacetime_score = (json['spacetime_score'] as num?)?.toInt(),
      _exec_score = (json['exec_score'] as num?)?.toInt(),
      _mem_score = (json['mem_score'] as num?)?.toInt(),
      _ling_score = (json['ling_score'] as num?)?.toInt(),
      _cal_score = (json['cal_score'] as num?)?.toInt(),
      _reac_score = (json['reac_score'] as num?)?.toInt(),
      _orient_score = (json['orient_score'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'month': _month, 'total_time': _total_time, 'avg_att': _avg_att, 'avg_med': _avg_med, 'firsts_name': _firsts_name, 'first_amt': _first_amt, 'second_name': _second_name, 'second_amt': _second_amt, 'con_score': _con_score, 'spacetime_score': _spacetime_score, 'exec_score': _exec_score, 'mem_score': _mem_score, 'ling_score': _ling_score, 'cal_score': _cal_score, 'reac_score': _reac_score, 'orient_score': _orient_score, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'month': _month,
    'total_time': _total_time,
    'avg_att': _avg_att,
    'avg_med': _avg_med,
    'firsts_name': _firsts_name,
    'first_amt': _first_amt,
    'second_name': _second_name,
    'second_amt': _second_amt,
    'con_score': _con_score,
    'spacetime_score': _spacetime_score,
    'exec_score': _exec_score,
    'mem_score': _mem_score,
    'ling_score': _ling_score,
    'cal_score': _cal_score,
    'reac_score': _reac_score,
    'orient_score': _orient_score,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MonthlyBrainSignalTable";
    modelSchemaDefinition.pluralName = "MonthlyBrainSignalTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'id',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'month',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'total_time',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'avg_att',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'avg_med',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'firsts_name',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'first_amt',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'second_name',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'second_amt',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'con_score',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'spacetime_score',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'exec_score',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'mem_score',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'ling_score',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'cal_score',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'reac_score',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'orient_score',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'createdAt',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'updatedAt',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}