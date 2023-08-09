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


/** This is an auto generated class representing the UserTable type in your schema. */
class UserTable {
  final String? _BIRTH;
  final amplify_core.TemporalDateTime? _CREATEDAT;
  final String? _ID;
  final String? _INSTITUTION;
  final String? _INSTITUTION_ID;
  final String? _NAME;
  final String? _SEX;
  final amplify_core.TemporalDateTime? _UPDATEDAT;

  String? get BIRTH {
    return _BIRTH;
  }
  
  amplify_core.TemporalDateTime? get CREATEDAT {
    return _CREATEDAT;
  }
  
  String get ID {
    try {
      return _ID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get INSTITUTION {
    return _INSTITUTION;
  }
  
  String? get INSTITUTION_ID {
    return _INSTITUTION_ID;
  }
  
  String? get NAME {
    return _NAME;
  }
  
  String? get SEX {
    return _SEX;
  }
  
  amplify_core.TemporalDateTime? get UPDATEDAT {
    return _UPDATEDAT;
  }
  
  const UserTable._internal({BIRTH, CREATEDAT, required ID, INSTITUTION, INSTITUTION_ID, NAME, SEX, UPDATEDAT}): _BIRTH = BIRTH, _CREATEDAT = CREATEDAT, _ID = ID, _INSTITUTION = INSTITUTION, _INSTITUTION_ID = INSTITUTION_ID, _NAME = NAME, _SEX = SEX, _UPDATEDAT = UPDATEDAT;
  
  factory UserTable({String? BIRTH, amplify_core.TemporalDateTime? CREATEDAT, required String ID, String? INSTITUTION, String? INSTITUTION_ID, String? NAME, String? SEX, amplify_core.TemporalDateTime? UPDATEDAT}) {
    return UserTable._internal(
      BIRTH: BIRTH,
      CREATEDAT: CREATEDAT,
      ID: ID,
      INSTITUTION: INSTITUTION,
      INSTITUTION_ID: INSTITUTION_ID,
      NAME: NAME,
      SEX: SEX,
      UPDATEDAT: UPDATEDAT);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserTable &&
      _BIRTH == other._BIRTH &&
      _CREATEDAT == other._CREATEDAT &&
      _ID == other._ID &&
      _INSTITUTION == other._INSTITUTION &&
      _INSTITUTION_ID == other._INSTITUTION_ID &&
      _NAME == other._NAME &&
      _SEX == other._SEX &&
      _UPDATEDAT == other._UPDATEDAT;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserTable {");
    buffer.write("BIRTH=" + "$_BIRTH" + ", ");
    buffer.write("CREATEDAT=" + (_CREATEDAT != null ? _CREATEDAT!.format() : "null") + ", ");
    buffer.write("ID=" + "$_ID" + ", ");
    buffer.write("INSTITUTION=" + "$_INSTITUTION" + ", ");
    buffer.write("INSTITUTION_ID=" + "$_INSTITUTION_ID" + ", ");
    buffer.write("NAME=" + "$_NAME" + ", ");
    buffer.write("SEX=" + "$_SEX" + ", ");
    buffer.write("UPDATEDAT=" + (_UPDATEDAT != null ? _UPDATEDAT!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserTable copyWith({String? BIRTH, amplify_core.TemporalDateTime? CREATEDAT, String? ID, String? INSTITUTION, String? INSTITUTION_ID, String? NAME, String? SEX, amplify_core.TemporalDateTime? UPDATEDAT}) {
    return UserTable._internal(
      BIRTH: BIRTH ?? this.BIRTH,
      CREATEDAT: CREATEDAT ?? this.CREATEDAT,
      ID: ID ?? this.ID,
      INSTITUTION: INSTITUTION ?? this.INSTITUTION,
      INSTITUTION_ID: INSTITUTION_ID ?? this.INSTITUTION_ID,
      NAME: NAME ?? this.NAME,
      SEX: SEX ?? this.SEX,
      UPDATEDAT: UPDATEDAT ?? this.UPDATEDAT);
  }
  
  UserTable copyWithModelFieldValues({
    ModelFieldValue<String?>? BIRTH,
    ModelFieldValue<amplify_core.TemporalDateTime?>? CREATEDAT,
    ModelFieldValue<String>? ID,
    ModelFieldValue<String?>? INSTITUTION,
    ModelFieldValue<String?>? INSTITUTION_ID,
    ModelFieldValue<String?>? NAME,
    ModelFieldValue<String?>? SEX,
    ModelFieldValue<amplify_core.TemporalDateTime?>? UPDATEDAT
  }) {
    return UserTable._internal(
      BIRTH: BIRTH == null ? this.BIRTH : BIRTH.value,
      CREATEDAT: CREATEDAT == null ? this.CREATEDAT : CREATEDAT.value,
      ID: ID == null ? this.ID : ID.value,
      INSTITUTION: INSTITUTION == null ? this.INSTITUTION : INSTITUTION.value,
      INSTITUTION_ID: INSTITUTION_ID == null ? this.INSTITUTION_ID : INSTITUTION_ID.value,
      NAME: NAME == null ? this.NAME : NAME.value,
      SEX: SEX == null ? this.SEX : SEX.value,
      UPDATEDAT: UPDATEDAT == null ? this.UPDATEDAT : UPDATEDAT.value
    );
  }
  
  UserTable.fromJson(Map<String, dynamic> json)  
    : _BIRTH = json['BIRTH'],
      _CREATEDAT = json['CREATEDAT'] != null ? amplify_core.TemporalDateTime.fromString(json['CREATEDAT']) : null,
      _ID = json['ID'],
      _INSTITUTION = json['INSTITUTION'],
      _INSTITUTION_ID = json['INSTITUTION_ID'],
      _NAME = json['NAME'],
      _SEX = json['SEX'],
      _UPDATEDAT = json['UPDATEDAT'] != null ? amplify_core.TemporalDateTime.fromString(json['UPDATEDAT']) : null;
  
  Map<String, dynamic> toJson() => {
    'BIRTH': _BIRTH, 'CREATEDAT': _CREATEDAT?.format(), 'ID': _ID, 'INSTITUTION': _INSTITUTION, 'INSTITUTION_ID': _INSTITUTION_ID, 'NAME': _NAME, 'SEX': _SEX, 'UPDATEDAT': _UPDATEDAT?.format()
  };
  
  Map<String, Object?> toMap() => {
    'BIRTH': _BIRTH,
    'CREATEDAT': _CREATEDAT,
    'ID': _ID,
    'INSTITUTION': _INSTITUTION,
    'INSTITUTION_ID': _INSTITUTION_ID,
    'NAME': _NAME,
    'SEX': _SEX,
    'UPDATEDAT': _UPDATEDAT
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserTable";
    modelSchemaDefinition.pluralName = "UserTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'BIRTH',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'CREATEDAT',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'INSTITUTION',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'INSTITUTION_ID',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'NAME',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'SEX',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'UPDATEDAT',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}