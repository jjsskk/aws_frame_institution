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


/** This is an auto generated class representing the InstitutionCommentBoardTable type in your schema. */
class InstitutionCommentBoardTable {
  final String? _BOARD_ID;
  final String? _USER_ID;
  final String? _WRITER;
  final String? _CONTENT;
  final String? _TITLE;
  final String? _USERNAME;
  final String? _INSTITUTION_ID;
  final bool? _NEW_CONVERSATION_PROTECTOR;
  final bool? _NEW_CONVERSATION_INST;
  final amplify_core.TemporalDateTime? _NEW_CONVERSATION_CREATEDAT;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  String get BOARD_ID {
    try {
      return _BOARD_ID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
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
  
  String? get WRITER {
    return _WRITER;
  }
  
  String? get CONTENT {
    return _CONTENT;
  }
  
  String? get TITLE {
    return _TITLE;
  }
  
  String? get USERNAME {
    return _USERNAME;
  }
  
  String? get INSTITUTION_ID {
    return _INSTITUTION_ID;
  }
  
  bool? get NEW_CONVERSATION_PROTECTOR {
    return _NEW_CONVERSATION_PROTECTOR;
  }
  
  bool? get NEW_CONVERSATION_INST {
    return _NEW_CONVERSATION_INST;
  }
  
  amplify_core.TemporalDateTime? get NEW_CONVERSATION_CREATEDAT {
    return _NEW_CONVERSATION_CREATEDAT;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const InstitutionCommentBoardTable._internal({required BOARD_ID, required USER_ID, WRITER, CONTENT, TITLE, USERNAME, INSTITUTION_ID, NEW_CONVERSATION_PROTECTOR, NEW_CONVERSATION_INST, NEW_CONVERSATION_CREATEDAT, createdAt, updatedAt}): _BOARD_ID = BOARD_ID, _USER_ID = USER_ID, _WRITER = WRITER, _CONTENT = CONTENT, _TITLE = TITLE, _USERNAME = USERNAME, _INSTITUTION_ID = INSTITUTION_ID, _NEW_CONVERSATION_PROTECTOR = NEW_CONVERSATION_PROTECTOR, _NEW_CONVERSATION_INST = NEW_CONVERSATION_INST, _NEW_CONVERSATION_CREATEDAT = NEW_CONVERSATION_CREATEDAT, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory InstitutionCommentBoardTable({required String BOARD_ID, required String USER_ID, String? WRITER, String? CONTENT, String? TITLE, String? USERNAME, String? INSTITUTION_ID, bool? NEW_CONVERSATION_PROTECTOR, bool? NEW_CONVERSATION_INST, amplify_core.TemporalDateTime? NEW_CONVERSATION_CREATEDAT, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionCommentBoardTable._internal(
      BOARD_ID: BOARD_ID,
      USER_ID: USER_ID,
      WRITER: WRITER,
      CONTENT: CONTENT,
      TITLE: TITLE,
      USERNAME: USERNAME,
      INSTITUTION_ID: INSTITUTION_ID,
      NEW_CONVERSATION_PROTECTOR: NEW_CONVERSATION_PROTECTOR,
      NEW_CONVERSATION_INST: NEW_CONVERSATION_INST,
      NEW_CONVERSATION_CREATEDAT: NEW_CONVERSATION_CREATEDAT,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InstitutionCommentBoardTable &&
      _BOARD_ID == other._BOARD_ID &&
      _USER_ID == other._USER_ID &&
      _WRITER == other._WRITER &&
      _CONTENT == other._CONTENT &&
      _TITLE == other._TITLE &&
      _USERNAME == other._USERNAME &&
      _INSTITUTION_ID == other._INSTITUTION_ID &&
      _NEW_CONVERSATION_PROTECTOR == other._NEW_CONVERSATION_PROTECTOR &&
      _NEW_CONVERSATION_INST == other._NEW_CONVERSATION_INST &&
      _NEW_CONVERSATION_CREATEDAT == other._NEW_CONVERSATION_CREATEDAT &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("InstitutionCommentBoardTable {");
    buffer.write("BOARD_ID=" + "$_BOARD_ID" + ", ");
    buffer.write("USER_ID=" + "$_USER_ID" + ", ");
    buffer.write("WRITER=" + "$_WRITER" + ", ");
    buffer.write("CONTENT=" + "$_CONTENT" + ", ");
    buffer.write("TITLE=" + "$_TITLE" + ", ");
    buffer.write("USERNAME=" + "$_USERNAME" + ", ");
    buffer.write("INSTITUTION_ID=" + "$_INSTITUTION_ID" + ", ");
    buffer.write("NEW_CONVERSATION_PROTECTOR=" + (_NEW_CONVERSATION_PROTECTOR != null ? _NEW_CONVERSATION_PROTECTOR!.toString() : "null") + ", ");
    buffer.write("NEW_CONVERSATION_INST=" + (_NEW_CONVERSATION_INST != null ? _NEW_CONVERSATION_INST!.toString() : "null") + ", ");
    buffer.write("NEW_CONVERSATION_CREATEDAT=" + (_NEW_CONVERSATION_CREATEDAT != null ? _NEW_CONVERSATION_CREATEDAT!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  InstitutionCommentBoardTable copyWith({String? BOARD_ID, String? USER_ID, String? WRITER, String? CONTENT, String? TITLE, String? USERNAME, String? INSTITUTION_ID, bool? NEW_CONVERSATION_PROTECTOR, bool? NEW_CONVERSATION_INST, amplify_core.TemporalDateTime? NEW_CONVERSATION_CREATEDAT, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionCommentBoardTable._internal(
      BOARD_ID: BOARD_ID ?? this.BOARD_ID,
      USER_ID: USER_ID ?? this.USER_ID,
      WRITER: WRITER ?? this.WRITER,
      CONTENT: CONTENT ?? this.CONTENT,
      TITLE: TITLE ?? this.TITLE,
      USERNAME: USERNAME ?? this.USERNAME,
      INSTITUTION_ID: INSTITUTION_ID ?? this.INSTITUTION_ID,
      NEW_CONVERSATION_PROTECTOR: NEW_CONVERSATION_PROTECTOR ?? this.NEW_CONVERSATION_PROTECTOR,
      NEW_CONVERSATION_INST: NEW_CONVERSATION_INST ?? this.NEW_CONVERSATION_INST,
      NEW_CONVERSATION_CREATEDAT: NEW_CONVERSATION_CREATEDAT ?? this.NEW_CONVERSATION_CREATEDAT,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  InstitutionCommentBoardTable copyWithModelFieldValues({
    ModelFieldValue<String>? BOARD_ID,
    ModelFieldValue<String>? USER_ID,
    ModelFieldValue<String?>? WRITER,
    ModelFieldValue<String?>? CONTENT,
    ModelFieldValue<String?>? TITLE,
    ModelFieldValue<String?>? USERNAME,
    ModelFieldValue<String?>? INSTITUTION_ID,
    ModelFieldValue<bool?>? NEW_CONVERSATION_PROTECTOR,
    ModelFieldValue<bool?>? NEW_CONVERSATION_INST,
    ModelFieldValue<amplify_core.TemporalDateTime?>? NEW_CONVERSATION_CREATEDAT,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return InstitutionCommentBoardTable._internal(
      BOARD_ID: BOARD_ID == null ? this.BOARD_ID : BOARD_ID.value,
      USER_ID: USER_ID == null ? this.USER_ID : USER_ID.value,
      WRITER: WRITER == null ? this.WRITER : WRITER.value,
      CONTENT: CONTENT == null ? this.CONTENT : CONTENT.value,
      TITLE: TITLE == null ? this.TITLE : TITLE.value,
      USERNAME: USERNAME == null ? this.USERNAME : USERNAME.value,
      INSTITUTION_ID: INSTITUTION_ID == null ? this.INSTITUTION_ID : INSTITUTION_ID.value,
      NEW_CONVERSATION_PROTECTOR: NEW_CONVERSATION_PROTECTOR == null ? this.NEW_CONVERSATION_PROTECTOR : NEW_CONVERSATION_PROTECTOR.value,
      NEW_CONVERSATION_INST: NEW_CONVERSATION_INST == null ? this.NEW_CONVERSATION_INST : NEW_CONVERSATION_INST.value,
      NEW_CONVERSATION_CREATEDAT: NEW_CONVERSATION_CREATEDAT == null ? this.NEW_CONVERSATION_CREATEDAT : NEW_CONVERSATION_CREATEDAT.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  InstitutionCommentBoardTable.fromJson(Map<String, dynamic> json)  
    : _BOARD_ID = json['BOARD_ID'],
      _USER_ID = json['USER_ID'],
      _WRITER = json['WRITER'],
      _CONTENT = json['CONTENT'],
      _TITLE = json['TITLE'],
      _USERNAME = json['USERNAME'],
      _INSTITUTION_ID = json['INSTITUTION_ID'],
      _NEW_CONVERSATION_PROTECTOR = json['NEW_CONVERSATION_PROTECTOR'],
      _NEW_CONVERSATION_INST = json['NEW_CONVERSATION_INST'],
      _NEW_CONVERSATION_CREATEDAT = json['NEW_CONVERSATION_CREATEDAT'] != null ? amplify_core.TemporalDateTime.fromString(json['NEW_CONVERSATION_CREATEDAT']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'BOARD_ID': _BOARD_ID, 'USER_ID': _USER_ID, 'WRITER': _WRITER, 'CONTENT': _CONTENT, 'TITLE': _TITLE, 'USERNAME': _USERNAME, 'INSTITUTION_ID': _INSTITUTION_ID, 'NEW_CONVERSATION_PROTECTOR': _NEW_CONVERSATION_PROTECTOR, 'NEW_CONVERSATION_INST': _NEW_CONVERSATION_INST, 'NEW_CONVERSATION_CREATEDAT': _NEW_CONVERSATION_CREATEDAT?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'BOARD_ID': _BOARD_ID,
    'USER_ID': _USER_ID,
    'WRITER': _WRITER,
    'CONTENT': _CONTENT,
    'TITLE': _TITLE,
    'USERNAME': _USERNAME,
    'INSTITUTION_ID': _INSTITUTION_ID,
    'NEW_CONVERSATION_PROTECTOR': _NEW_CONVERSATION_PROTECTOR,
    'NEW_CONVERSATION_INST': _NEW_CONVERSATION_INST,
    'NEW_CONVERSATION_CREATEDAT': _NEW_CONVERSATION_CREATEDAT,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "InstitutionCommentBoardTable";
    modelSchemaDefinition.pluralName = "InstitutionCommentBoardTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'BOARD_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'USER_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'WRITER',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'CONTENT',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'TITLE',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'USERNAME',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'INSTITUTION_ID',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'NEW_CONVERSATION_PROTECTOR',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'NEW_CONVERSATION_INST',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'NEW_CONVERSATION_CREATEDAT',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
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