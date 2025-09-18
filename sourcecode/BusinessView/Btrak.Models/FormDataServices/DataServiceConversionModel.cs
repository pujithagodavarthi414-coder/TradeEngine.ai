using Btrak.Models.CustomApplication;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
    public class DataServiceConversionModel
    {
        public dynamic Components { get; set; } 
        public Guid? FormTypeId { get; set; }
        public bool? IsAbleToLogin { get; set; }
        public bool? AllowAnnonymous { get; set; }
        public Guid? ReferenceTypeId { get; set; }
        public Guid? ReferenceId { get; set; }
        public int? ModuleTypeId { get; set; }
    }
    public class Component
    {
        public string Label { get; set; }
        public string Legend { get; set; }
        public object data { get; set; }
        public object Values { get; set; }
        public string Title { get; set; }
        public bool Input { get; set; }
        public string Key { get; set; }
        public string html { get; set; }
        public string content { get; set; }
        public int numRows { get; set; }
        public int? DecimalLimit { get; set; }
        public int numCols { get; set; }
        public string Type { get; set; }
        public bool multiple { get; set; }
        public string DisplayAs { get; set; }
        public string ImportDataType { get; set; }
        public bool TableView { get; set; }
        public string ValueSelection { get; set; }
        public int? ValueSelectionLimit { get; set; }
        public List<Component> Components { get; set; }
        public bool? UploadOnly { get; set; }
        public object Properties { get; set; }
        public object FileTypes { get; set; }

        public string Placeholder { get; set; }
        public object DefaultValue { get; set; }
        public string Description { get; set; }
        public string Tooltip { get; set; }
        public dynamic Columns { get; set; }
        public dynamic Rows { get; set; }
        public string[] UserView { get; set; }
        public string[] UserEdit { get;set;}
        public string[] RoleView { get; set; }
        public string[] RoleEdit { get; set; }
        public string[] RelatedFieldsLabel { get; set; }
        public string GenricFormName { get; set; }
        public string FormName { get; set; }
        public string[] Relatedfield { get; set; }
        public string FieldName { get; set; }
        public string SelectedFormName { get; set; }
        public object RelatedFieldsfinalData { get; set; }
        public string[] RelatedFormsFields { get; set; }
        public string DataType { get; set; }
        public Guid? FormTypeId { get; set; }
        public string CalculateValue { get; set; }
        public string Action { get; set; }
        public string State { get; set; }
        public object Format { get; set; }
        public object Conditional { get; set; }
        public object Logic { get; set; }
        public object ElseLogic { get; set; }
        public object ValueForElse { get; set; }
        public object EmptyOrNull { get; set; }
        public object ValueForEmptyOrNull { get; set; }
        public string ConcatSplitKey { get; set; }
        public string[] ConcateFormFields { get; set; }
        public string DateTimeForLinkedFields { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public bool? FilterFieldsBasedOnForm { get; set; }
        public string FilterFormName { get; set; }
        public bool? IsAddOptionRequired { get; set; }
        public bool? IsMultiSelectOptionRequired { get; set; }
        public string Operator { get; set; }
        public string CalculateFieldName { get; set; }
        public CustomApplicationSearchOutputModel selectedForm { get; set; }
        public string dataSrc { get; set; }
        public Guid? customAppName { get; set; }
        public Guid? formName { get; set; }
    }

    public class RowsModel
    {
        public List<Component> Components { get; set; }
    }

    public class ColumnsModel
    {
        public List<Component> Components { get; set; }
    }
}
