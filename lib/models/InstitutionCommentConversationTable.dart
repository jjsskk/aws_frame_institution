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


/** This is an auto generated class representing the InstitutionCommentConversationTable type in your schema. */
class InstitutionCommentConversationTable {
  final String? _BOARD_ID;
  final String? _CONVERSATION_ID;
  final String? _EMAIL;
  final String? _CONTENT;
  final String? _WRITER;
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
  
  String get CONVERSATION_ID {
    try {
      return _CONVERSATION_ID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get EMAIL {
    return _EMAIL;
  }
  
  String? get CONTENT {
    return _CONTENT;
  }
  
  String? get WRITER {
    return _WRITER;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const InstitutionCommentConversationTable._internal({required BOARD_ID, required CONVERSATION_ID, EMAIL, CONTENT, WRITER, createdAt, updatedAt}): _BOARD_ID = BOARD_ID, _CONVERSATION_ID = CONVERSATION_ID, _EMAIL = EMAIL, _CONTENT = CONTENT, _WRITER = WRITER, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory InstitutionCommentConversationTable({required String BOARD_ID, required String CONVERSATION_ID, String? EMAIL, String? CONTENT, String? WRITER, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionCommentConversationTable._internal(
      BOARD_ID: BOARD_ID,
      CONVERSATION_ID: CONVERSATION_ID,
      EMAIL: EMAIL,
      CONTENT: CONTENT,
      WRITER: WRITER,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InstitutionCommentConversationTable &&
      _BOARD_ID == other._BOARD_ID &&
      _CONVERSATION_ID == other._CONVERSATION_ID &&
      _EMAIL == other._EMAIL &&
      _CONTENT == other._CONTENT &&
      _WRITER == other._WRITER &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("InstitutionCommentConversationTable {");
    buffer.write("BOARD_ID=" + "$_BOARD_ID" + ", ");
    buffer.write("CONVERSATION_ID=" + "$_CONVERSATION_ID" + ", ");
    buffer.write("EMAIL=" + "$_EMAIL" + ", ");
    buffer.write("CONTENT=" + "$_CONTENT" + ", ");
    buffer.write("WRITER=" + "$_WRITER" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  InstitutionCommentConversationTable copyWith({String? BOARD_ID, String? CONVERSATION_ID, String? EMAIL, String? CONTENT, String? WRITER, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionCommentConversationTable._internal(
      BOARD_ID: BOARD_ID ?? this.BOARD_ID,
      CONVERSATION_ID: CONVERSATION_ID ?? this.CONVERSATION_ID,
      EMAIL: EMAIL ?? this.EMAIL,
      CONTENT: CONTENT ?? this.CONTENT,
      WRITER: WRITER ?? this.WRITER,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  InstitutionCommentConversationTable copyWithModelFieldValues({
    ModelFieldValue<String>? BOARD_ID,
    ModelFieldValue<String>? CONVERSATION_ID,
    ModelFieldValue<String?>? EMAIL,
    ModelFieldValue<String?>? CONTENT,
    ModelFieldValue<String?>? WRITER,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return InstitutionCommentConversationTable._internal(
      BOARD_ID: BOARD_ID == null ? this.BOARD_ID : BOARD_ID.value,
      CONVERSATION_ID: CONVERSATION_ID == null ? this.CONVERSATION_ID : CONVERSATION_ID.value,
      EMAIL: EMAIL == null ? this.EMAIL : EMAIL.value,
      CONTENT: CONTENT == null ? this.CONTENT : CONTENT.value,
      WRITER: WRITER == null ? this.WRITER : WRITER.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  InstitutionCommentConversationTable.fromJson(Map<String, dynamic> json)  
    : _BOARD_ID = json['BOARD_ID'],
      _CONVERSATION_ID = json['CONVERSATION_ID'],
      _EMAIL = json['EMAIL'],
      _CONTENT = json['CONTENT'],
      _WRITER = json['WRITER'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'BOARD_ID': _BOARD_ID, 'CONVERSATION_ID': _CONVERSATION_ID, 'EMAIL': _EMAIL, 'CONTENT': _CONTENT, 'WRITER': _WRITER, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'BOARD_ID': _BOARD_ID,
    'CONVERSATION_ID': _CONVERSATION_ID,
    'EMAIL': _EMAIL,
    'CONTENT': _CONTENT,
    'WRITER': _WRITER,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "InstitutionCommentConversationTable";
    modelSchemaDefinition.pluralName = "InstitutionCommentConversationTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'BOARD_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'CONVERSATION_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'EMAIL',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'CONTENT',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'WRITER',
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