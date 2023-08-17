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

import 'package:amplify_core/amplify_core.dart';

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the InstitutionAnnouncementTable type in your schema. */
class InstitutionAnnouncementTable extends Model {
  final String? _ANNOUNCEMENT_ID;
  final String? _CONTENT;
  final String? _IMAGE;
  final String? _INSTITUTION;
  final String? _INSTITUTION_ID;
  final String? _TITLE;
  final String? _URL;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  String get ANNOUNCEMENT_ID {
    try {
      return _ANNOUNCEMENT_ID!;
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
  
  String? get IMAGE {
    return _IMAGE;
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
  
  String? get TITLE {
    return _TITLE;
  }
  
  String? get URL {
    return _URL;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const InstitutionAnnouncementTable._internal({required ANNOUNCEMENT_ID, CONTENT, IMAGE, INSTITUTION, required INSTITUTION_ID, TITLE, URL, createdAt, updatedAt}): _ANNOUNCEMENT_ID = ANNOUNCEMENT_ID, _CONTENT = CONTENT, _IMAGE = IMAGE, _INSTITUTION = INSTITUTION, _INSTITUTION_ID = INSTITUTION_ID, _TITLE = TITLE, _URL = URL, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory InstitutionAnnouncementTable({required String ANNOUNCEMENT_ID, String? CONTENT, String? IMAGE, String? INSTITUTION, required String INSTITUTION_ID, String? TITLE, String? URL, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionAnnouncementTable._internal(
      ANNOUNCEMENT_ID: ANNOUNCEMENT_ID,
      CONTENT: CONTENT,
      IMAGE: IMAGE,
      INSTITUTION: INSTITUTION,
      INSTITUTION_ID: INSTITUTION_ID,
      TITLE: TITLE,
      URL: URL,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InstitutionAnnouncementTable &&
      _ANNOUNCEMENT_ID == other._ANNOUNCEMENT_ID &&
      _CONTENT == other._CONTENT &&
      _IMAGE == other._IMAGE &&
      _INSTITUTION == other._INSTITUTION &&
      _INSTITUTION_ID == other._INSTITUTION_ID &&
      _TITLE == other._TITLE &&
      _URL == other._URL &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("InstitutionAnnouncementTable {");
    buffer.write("ANNOUNCEMENT_ID=" + "$_ANNOUNCEMENT_ID" + ", ");
    buffer.write("CONTENT=" + "$_CONTENT" + ", ");
    buffer.write("IMAGE=" + "$_IMAGE" + ", ");
    buffer.write("INSTITUTION=" + "$_INSTITUTION" + ", ");
    buffer.write("INSTITUTION_ID=" + "$_INSTITUTION_ID" + ", ");
    buffer.write("TITLE=" + "$_TITLE" + ", ");
    buffer.write("URL=" + "$_URL" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  InstitutionAnnouncementTable copyWith({String? ANNOUNCEMENT_ID, String? CONTENT, String? IMAGE, String? INSTITUTION, String? INSTITUTION_ID, String? TITLE, String? URL, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionAnnouncementTable._internal(
      ANNOUNCEMENT_ID: ANNOUNCEMENT_ID ?? this.ANNOUNCEMENT_ID,
      CONTENT: CONTENT ?? this.CONTENT,
      IMAGE: IMAGE ?? this.IMAGE,
      INSTITUTION: INSTITUTION ?? this.INSTITUTION,
      INSTITUTION_ID: INSTITUTION_ID ?? this.INSTITUTION_ID,
      TITLE: TITLE ?? this.TITLE,
      URL: URL ?? this.URL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  InstitutionAnnouncementTable copyWithModelFieldValues({
    ModelFieldValue<String>? ANNOUNCEMENT_ID,
    ModelFieldValue<String?>? CONTENT,
    ModelFieldValue<String?>? IMAGE,
    ModelFieldValue<String?>? INSTITUTION,
    ModelFieldValue<String>? INSTITUTION_ID,
    ModelFieldValue<String?>? TITLE,
    ModelFieldValue<String?>? URL,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return InstitutionAnnouncementTable._internal(
      ANNOUNCEMENT_ID: ANNOUNCEMENT_ID == null ? this.ANNOUNCEMENT_ID : ANNOUNCEMENT_ID.value,
      CONTENT: CONTENT == null ? this.CONTENT : CONTENT.value,
      IMAGE: IMAGE == null ? this.IMAGE : IMAGE.value,
      INSTITUTION: INSTITUTION == null ? this.INSTITUTION : INSTITUTION.value,
      INSTITUTION_ID: INSTITUTION_ID == null ? this.INSTITUTION_ID : INSTITUTION_ID.value,
      TITLE: TITLE == null ? this.TITLE : TITLE.value,
      URL: URL == null ? this.URL : URL.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  InstitutionAnnouncementTable.fromJson(Map<String, dynamic> json)  
    : _ANNOUNCEMENT_ID = json['ANNOUNCEMENT_ID'],
      _CONTENT = json['CONTENT'],
      _IMAGE = json['IMAGE'],
      _INSTITUTION = json['INSTITUTION'],
      _INSTITUTION_ID = json['INSTITUTION_ID'],
      _TITLE = json['TITLE'],
      _URL = json['URL'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'ANNOUNCEMENT_ID': _ANNOUNCEMENT_ID, 'CONTENT': _CONTENT, 'IMAGE': _IMAGE, 'INSTITUTION': _INSTITUTION, 'INSTITUTION_ID': _INSTITUTION_ID, 'TITLE': _TITLE, 'URL': _URL, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'ANNOUNCEMENT_ID': _ANNOUNCEMENT_ID,
    'CONTENT': _CONTENT,
    'IMAGE': _IMAGE,
    'INSTITUTION': _INSTITUTION,
    'INSTITUTION_ID': _INSTITUTION_ID,
    'TITLE': _TITLE,
    'URL': _URL,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "InstitutionAnnouncementTable";
    modelSchemaDefinition.pluralName = "InstitutionAnnouncementTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'ANNOUNCEMENT_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'CONTENT',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'IMAGE',
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
      fieldName: 'TITLE',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'URL',
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

