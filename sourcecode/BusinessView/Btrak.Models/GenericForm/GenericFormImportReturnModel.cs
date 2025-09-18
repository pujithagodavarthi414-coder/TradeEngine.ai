using Btrak.Models.CustomApplication;
using System;
using System.Collections.Generic;

namespace Btrak.Models.GenericForm
{
    public class GenericFormImportReturnModel
    {
        public string ExcelHeader { get; set; }

        public string FormHeader { get; set; }

        public string SampleData { get; set; }

        public bool IsItGoodToImport { get; set; }
    }

    public class FormData
    {
        public List<ExcelPair> FormKeyValuePairs { get; set; }
    }

    public class ExcelPair
    {
        public string Key { get; set; }

        public string Value { get; set; }
        public string Header { get; set; }
    }

    public class FormPair
    {
        public string Label { get; set; }

        public string Key { get; set; }
        public string Type { get; set; }
        public int? DecimalLimit { get; set; }
    }

    public class ExcelSheetRawModel
    {
        public string SheetName { get; set; }

        public List<string> ExcelHeaders { get; set; }

        public List<FormData> SheetData { get; set; }

        public Guid? SelectedFormId { get; set; }

        public Guid? ApplicationId { get; set; }

        public List<GenericFormImportReturnModel> ImportValidations { get; set; }
    }

    public class AppFormRawModel
    {
        public string FormName { get; set; }

        public Guid? FormId { get; set; }

        public List<FormPair> LabelKeyPairs { get; set; }
    }

    public class FormImportsRawModel
    {
        public List<ExcelSheetRawModel> Sheets { get; set; }

        public List<AppFormRawModel> Forms { get; set; }

        public Guid? ApplicationId { get; set; }

        public string CustomApplicationName { get; set; }

        public List<CustomFieldMappingApiOutputModel> MappingsList { get; set; }

        public string MappingName { get; set; }

        public Guid? SelectedMappingId { get; set; }

        public string MappingJson { get; set; }
    }

    public class ValidatedSheetsImportModel
    {
       public List<ExcelSheetRawModel> FormImports { get; set; }

        public Guid? SelectedMappingId { get; set; }

        public Guid? CustomApplicationId { get; set; }

        public string MappingName { get; set; }

        public byte[] TimeStamp { get; set; }
    }
}
