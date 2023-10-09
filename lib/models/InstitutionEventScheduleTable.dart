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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the InstitutionEventScheduleTable type in your schema. */
class InstitutionEventScheduleTable {
  final String? _INSTITUTION_ID;
  final String? _SCHEDULE_ID;
  final String? _CONTENT;
  final List<String>? _TAG;
  final String? _TIME;
  final String? _DATE;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  String get INSTITUTION_ID {
    try {
      return _INSTITUTION_ID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get SCHEDULE_ID {
    try {
      return _SCHEDULE_ID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get CONTENT {
    return _CONTENT;
  }
  
  List<String>? get TAG {
    return _TAG;
  }
  
  String? get TIME {
    return _TIME;
  }
  
  String? get DATE {
    return _DATE;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const InstitutionEventScheduleTable._internal({required INSTITUTION_ID, required SCHEDULE_ID, CONTENT, TAG, TIME, DATE, createdAt, updatedAt}): _INSTITUTION_ID = INSTITUTION_ID, _SCHEDULE_ID = SCHEDULE_ID, _CONTENT = CONTENT, _TAG = TAG, _TIME = TIME, _DATE = DATE, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory InstitutionEventScheduleTable({required String INSTITUTION_ID, required String SCHEDULE_ID, String? CONTENT, List<String>? TAG, String? TIME, String? DATE, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionEventScheduleTable._internal(
      INSTITUTION_ID: INSTITUTION_ID,
      SCHEDULE_ID: SCHEDULE_ID,
      CONTENT: CONTENT,
      TAG: TAG != null ? List<String>.unmodifiable(TAG) : TAG,
      TIME: TIME,
      DATE: DATE,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InstitutionEventScheduleTable &&
      _INSTITUTION_ID == other._INSTITUTION_ID &&
      _SCHEDULE_ID == other._SCHEDULE_ID &&
      _CONTENT == other._CONTENT &&
      DeepCollectionEquality().equals(_TAG, other._TAG) &&
      _TIME == other._TIME &&
      _DATE == other._DATE &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("InstitutionEventScheduleTable {");
    buffer.write("INSTITUTION_ID=" + "$_INSTITUTION_ID" + ", ");
    buffer.write("SCHEDULE_ID=" + "$_SCHEDULE_ID" + ", ");
    buffer.write("CONTENT=" + "$_CONTENT" + ", ");
    buffer.write("TAG=" + (_TAG != null ? _TAG!.toString() : "null") + ", ");
    buffer.write("TIME=" + "$_TIME" + ", ");
    buffer.write("DATE=" + "$_DATE" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  InstitutionEventScheduleTable copyWith({String? INSTITUTION_ID, String? SCHEDULE_ID, String? CONTENT, List<String>? TAG, String? TIME, String? DATE, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionEventScheduleTable._internal(
      INSTITUTION_ID: INSTITUTION_ID ?? this.INSTITUTION_ID,
      SCHEDULE_ID: SCHEDULE_ID ?? this.SCHEDULE_ID,
      CONTENT: CONTENT ?? this.CONTENT,
      TAG: TAG ?? this.TAG,
      TIME: TIME ?? this.TIME,
      DATE: DATE ?? this.DATE,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  InstitutionEventScheduleTable copyWithModelFieldValues({
    ModelFieldValue<String>? INSTITUTION_ID,
    ModelFieldValue<String>? SCHEDULE_ID,
    ModelFieldValue<String?>? CONTENT,
    ModelFieldValue<List<String>?>? TAG,
    ModelFieldValue<String?>? TIME,
    ModelFieldValue<String?>? DATE,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return InstitutionEventScheduleTable._internal(
      INSTITUTION_ID: INSTITUTION_ID == null ? this.INSTITUTION_ID : INSTITUTION_ID.value,
      SCHEDULE_ID: SCHEDULE_ID == null ? this.SCHEDULE_ID : SCHEDULE_ID.value,
      CONTENT: CONTENT == null ? this.CONTENT : CONTENT.value,
      TAG: TAG == null ? this.TAG : TAG.value,
      TIME: TIME == null ? this.TIME : TIME.value,
      DATE: DATE == null ? this.DATE : DATE.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  InstitutionEventScheduleTable.fromJson(Map<String, dynamic> json)  
    : _INSTITUTION_ID = json['INSTITUTION_ID'],
      _SCHEDULE_ID = json['SCHEDULE_ID'],
      _CONTENT = json['CONTENT'],
      _TAG = json['TAG']?.cast<String>(),
      _TIME = json['TIME'],
      _DATE = json['DATE'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'INSTITUTION_ID': _INSTITUTION_ID, 'SCHEDULE_ID': _SCHEDULE_ID, 'CONTENT': _CONTENT, 'TAG': _TAG, 'TIME': _TIME, 'DATE': _DATE, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'INSTITUTION_ID': _INSTITUTION_ID,
    'SCHEDULE_ID': _SCHEDULE_ID,
    'CONTENT': _CONTENT,
    'TAG': _TAG,
    'TIME': _TIME,
    'DATE': _DATE,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "InstitutionEventScheduleTable";
    modelSchemaDefinition.pluralName = "InstitutionEventScheduleTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'INSTITUTION_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'SCHEDULE_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'CONTENT',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'TAG',
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'TIME',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'DATE',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
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