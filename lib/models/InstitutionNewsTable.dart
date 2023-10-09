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


/** This is an auto generated class representing the InstitutionNewsTable type in your schema. */
class InstitutionNewsTable {
  final String? _INSTITUTION_ID;
  final String? _NEWS_ID;
  final String? _CONTENT;
  final String? _IMAGE;
  final String? _INSTITUTION;
  final String? _TITLE;
  final String? _URL;
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
  
  String get NEWS_ID {
    try {
      return _NEWS_ID!;
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
  
  const InstitutionNewsTable._internal({required INSTITUTION_ID, required NEWS_ID, CONTENT, IMAGE, INSTITUTION, TITLE, URL, createdAt, updatedAt}): _INSTITUTION_ID = INSTITUTION_ID, _NEWS_ID = NEWS_ID, _CONTENT = CONTENT, _IMAGE = IMAGE, _INSTITUTION = INSTITUTION, _TITLE = TITLE, _URL = URL, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory InstitutionNewsTable({required String INSTITUTION_ID, required String NEWS_ID, String? CONTENT, String? IMAGE, String? INSTITUTION, String? TITLE, String? URL, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionNewsTable._internal(
      INSTITUTION_ID: INSTITUTION_ID,
      NEWS_ID: NEWS_ID,
      CONTENT: CONTENT,
      IMAGE: IMAGE,
      INSTITUTION: INSTITUTION,
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
    return other is InstitutionNewsTable &&
      _INSTITUTION_ID == other._INSTITUTION_ID &&
      _NEWS_ID == other._NEWS_ID &&
      _CONTENT == other._CONTENT &&
      _IMAGE == other._IMAGE &&
      _INSTITUTION == other._INSTITUTION &&
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
    
    buffer.write("InstitutionNewsTable {");
    buffer.write("INSTITUTION_ID=" + "$_INSTITUTION_ID" + ", ");
    buffer.write("NEWS_ID=" + "$_NEWS_ID" + ", ");
    buffer.write("CONTENT=" + "$_CONTENT" + ", ");
    buffer.write("IMAGE=" + "$_IMAGE" + ", ");
    buffer.write("INSTITUTION=" + "$_INSTITUTION" + ", ");
    buffer.write("TITLE=" + "$_TITLE" + ", ");
    buffer.write("URL=" + "$_URL" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  InstitutionNewsTable copyWith({String? INSTITUTION_ID, String? NEWS_ID, String? CONTENT, String? IMAGE, String? INSTITUTION, String? TITLE, String? URL, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionNewsTable._internal(
      INSTITUTION_ID: INSTITUTION_ID ?? this.INSTITUTION_ID,
      NEWS_ID: NEWS_ID ?? this.NEWS_ID,
      CONTENT: CONTENT ?? this.CONTENT,
      IMAGE: IMAGE ?? this.IMAGE,
      INSTITUTION: INSTITUTION ?? this.INSTITUTION,
      TITLE: TITLE ?? this.TITLE,
      URL: URL ?? this.URL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  InstitutionNewsTable copyWithModelFieldValues({
    ModelFieldValue<String>? INSTITUTION_ID,
    ModelFieldValue<String>? NEWS_ID,
    ModelFieldValue<String?>? CONTENT,
    ModelFieldValue<String?>? IMAGE,
    ModelFieldValue<String?>? INSTITUTION,
    ModelFieldValue<String?>? TITLE,
    ModelFieldValue<String?>? URL,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return InstitutionNewsTable._internal(
      INSTITUTION_ID: INSTITUTION_ID == null ? this.INSTITUTION_ID : INSTITUTION_ID.value,
      NEWS_ID: NEWS_ID == null ? this.NEWS_ID : NEWS_ID.value,
      CONTENT: CONTENT == null ? this.CONTENT : CONTENT.value,
      IMAGE: IMAGE == null ? this.IMAGE : IMAGE.value,
      INSTITUTION: INSTITUTION == null ? this.INSTITUTION : INSTITUTION.value,
      TITLE: TITLE == null ? this.TITLE : TITLE.value,
      URL: URL == null ? this.URL : URL.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  InstitutionNewsTable.fromJson(Map<String, dynamic> json)  
    : _INSTITUTION_ID = json['INSTITUTION_ID'],
      _NEWS_ID = json['NEWS_ID'],
      _CONTENT = json['CONTENT'],
      _IMAGE = json['IMAGE'],
      _INSTITUTION = json['INSTITUTION'],
      _TITLE = json['TITLE'],
      _URL = json['URL'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'INSTITUTION_ID': _INSTITUTION_ID, 'NEWS_ID': _NEWS_ID, 'CONTENT': _CONTENT, 'IMAGE': _IMAGE, 'INSTITUTION': _INSTITUTION, 'TITLE': _TITLE, 'URL': _URL, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'INSTITUTION_ID': _INSTITUTION_ID,
    'NEWS_ID': _NEWS_ID,
    'CONTENT': _CONTENT,
    'IMAGE': _IMAGE,
    'INSTITUTION': _INSTITUTION,
    'TITLE': _TITLE,
    'URL': _URL,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "InstitutionNewsTable";
    modelSchemaDefinition.pluralName = "InstitutionNewsTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'INSTITUTION_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'NEWS_ID',
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