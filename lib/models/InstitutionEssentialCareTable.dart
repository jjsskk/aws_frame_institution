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


/** This is an auto generated class representing the InstitutionEssentialCareTable type in your schema. */
class InstitutionEssentialCareTable {
  final String? _BIRTH;
  final String? _INSTITUTION;
  final String? _INSTITUTION_ID;
  final String? _MEDICATION;
  final String? _MEDICATION_WAY;
  final String? _NAME;
  final String? _PHONE_NUMBER;
  final String? _USER_ID;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  String? get BIRTH {
    return _BIRTH;
  }
  
  String? get INSTITUTION {
    return _INSTITUTION;
  }
  
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
  
  String? get MEDICATION {
    return _MEDICATION;
  }
  
  String? get MEDICATION_WAY {
    return _MEDICATION_WAY;
  }
  
  String? get NAME {
    return _NAME;
  }
  
  String? get PHONE_NUMBER {
    return _PHONE_NUMBER;
  }
  
  String get USER_ID {
    try {
      return _USER_ID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const InstitutionEssentialCareTable._internal({BIRTH, INSTITUTION, required INSTITUTION_ID, MEDICATION, MEDICATION_WAY, NAME, PHONE_NUMBER, required USER_ID, createdAt, updatedAt}): _BIRTH = BIRTH, _INSTITUTION = INSTITUTION, _INSTITUTION_ID = INSTITUTION_ID, _MEDICATION = MEDICATION, _MEDICATION_WAY = MEDICATION_WAY, _NAME = NAME, _PHONE_NUMBER = PHONE_NUMBER, _USER_ID = USER_ID, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory InstitutionEssentialCareTable({String? BIRTH, String? INSTITUTION, required String INSTITUTION_ID, String? MEDICATION, String? MEDICATION_WAY, String? NAME, String? PHONE_NUMBER, required String USER_ID, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionEssentialCareTable._internal(
      BIRTH: BIRTH,
      INSTITUTION: INSTITUTION,
      INSTITUTION_ID: INSTITUTION_ID,
      MEDICATION: MEDICATION,
      MEDICATION_WAY: MEDICATION_WAY,
      NAME: NAME,
      PHONE_NUMBER: PHONE_NUMBER,
      USER_ID: USER_ID,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InstitutionEssentialCareTable &&
      _BIRTH == other._BIRTH &&
      _INSTITUTION == other._INSTITUTION &&
      _INSTITUTION_ID == other._INSTITUTION_ID &&
      _MEDICATION == other._MEDICATION &&
      _MEDICATION_WAY == other._MEDICATION_WAY &&
      _NAME == other._NAME &&
      _PHONE_NUMBER == other._PHONE_NUMBER &&
      _USER_ID == other._USER_ID &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("InstitutionEssentialCareTable {");
    buffer.write("BIRTH=" + "$_BIRTH" + ", ");
    buffer.write("INSTITUTION=" + "$_INSTITUTION" + ", ");
    buffer.write("INSTITUTION_ID=" + "$_INSTITUTION_ID" + ", ");
    buffer.write("MEDICATION=" + "$_MEDICATION" + ", ");
    buffer.write("MEDICATION_WAY=" + "$_MEDICATION_WAY" + ", ");
    buffer.write("NAME=" + "$_NAME" + ", ");
    buffer.write("PHONE_NUMBER=" + "$_PHONE_NUMBER" + ", ");
    buffer.write("USER_ID=" + "$_USER_ID" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  InstitutionEssentialCareTable copyWith({String? BIRTH, String? INSTITUTION, String? INSTITUTION_ID, String? MEDICATION, String? MEDICATION_WAY, String? NAME, String? PHONE_NUMBER, String? USER_ID, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionEssentialCareTable._internal(
      BIRTH: BIRTH ?? this.BIRTH,
      INSTITUTION: INSTITUTION ?? this.INSTITUTION,
      INSTITUTION_ID: INSTITUTION_ID ?? this.INSTITUTION_ID,
      MEDICATION: MEDICATION ?? this.MEDICATION,
      MEDICATION_WAY: MEDICATION_WAY ?? this.MEDICATION_WAY,
      NAME: NAME ?? this.NAME,
      PHONE_NUMBER: PHONE_NUMBER ?? this.PHONE_NUMBER,
      USER_ID: USER_ID ?? this.USER_ID,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  InstitutionEssentialCareTable copyWithModelFieldValues({
    ModelFieldValue<String?>? BIRTH,
    ModelFieldValue<String?>? INSTITUTION,
    ModelFieldValue<String>? INSTITUTION_ID,
    ModelFieldValue<String?>? MEDICATION,
    ModelFieldValue<String?>? MEDICATION_WAY,
    ModelFieldValue<String?>? NAME,
    ModelFieldValue<String?>? PHONE_NUMBER,
    ModelFieldValue<String>? USER_ID,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return InstitutionEssentialCareTable._internal(
      BIRTH: BIRTH == null ? this.BIRTH : BIRTH.value,
      INSTITUTION: INSTITUTION == null ? this.INSTITUTION : INSTITUTION.value,
      INSTITUTION_ID: INSTITUTION_ID == null ? this.INSTITUTION_ID : INSTITUTION_ID.value,
      MEDICATION: MEDICATION == null ? this.MEDICATION : MEDICATION.value,
      MEDICATION_WAY: MEDICATION_WAY == null ? this.MEDICATION_WAY : MEDICATION_WAY.value,
      NAME: NAME == null ? this.NAME : NAME.value,
      PHONE_NUMBER: PHONE_NUMBER == null ? this.PHONE_NUMBER : PHONE_NUMBER.value,
      USER_ID: USER_ID == null ? this.USER_ID : USER_ID.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  InstitutionEssentialCareTable.fromJson(Map<String, dynamic> json)  
    : _BIRTH = json['BIRTH'],
      _INSTITUTION = json['INSTITUTION'],
      _INSTITUTION_ID = json['INSTITUTION_ID'],
      _MEDICATION = json['MEDICATION'],
      _MEDICATION_WAY = json['MEDICATION_WAY'],
      _NAME = json['NAME'],
      _PHONE_NUMBER = json['PHONE_NUMBER'],
      _USER_ID = json['USER_ID'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'BIRTH': _BIRTH, 'INSTITUTION': _INSTITUTION, 'INSTITUTION_ID': _INSTITUTION_ID, 'MEDICATION': _MEDICATION, 'MEDICATION_WAY': _MEDICATION_WAY, 'NAME': _NAME, 'PHONE_NUMBER': _PHONE_NUMBER, 'USER_ID': _USER_ID, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'BIRTH': _BIRTH,
    'INSTITUTION': _INSTITUTION,
    'INSTITUTION_ID': _INSTITUTION_ID,
    'MEDICATION': _MEDICATION,
    'MEDICATION_WAY': _MEDICATION_WAY,
    'NAME': _NAME,
    'PHONE_NUMBER': _PHONE_NUMBER,
    'USER_ID': _USER_ID,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "InstitutionEssentialCareTable";
    modelSchemaDefinition.pluralName = "InstitutionEssentialCareTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'BIRTH',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'INSTITUTION',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'INSTITUTION_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'MEDICATION',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'MEDICATION_WAY',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'NAME',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'PHONE_NUMBER',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'USER_ID',
      isRequired: true,
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