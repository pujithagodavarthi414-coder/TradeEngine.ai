using Btrak.Models.CustomApplication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.FormDataServices
{
   public class DataSourceKeysInputModel
    {
        public Guid? Id { get; set; }
        public Guid? DataSourceId { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public string Type { get; set; }
        public string Title { get; set; }
        public int? DecimalLimit { get; set; }
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
        public string Format { get; set; }
        public string ConcatSplitKey { get; set; }
        public string[] ConcateFormFields { get; set; }
        public string DateTimeForLinkedFields { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public bool? IsAddOptionRequired { get; set; }
        public bool? IsMultiSelectOptionRequired { get; set; }
        public CustomApplicationSearchOutputModel selectedForm { get; set; }
        public string dataSrc { get; set; }
        public Guid? customAppName { get; set; }
        public Guid? formName { get; set; }
        public string fieldName { get; set; }
        public string Path { get; set; }
        public string Operator { get; set; }
        public string CalculateFieldName { get; set; }
        public string ValueSelection { get; set; }
        public string CalculateValue { get; set; }
        public bool? Unique { get; set; }
        public PropertiesModel Properties { get; set; }
    }
    public class LookupLinkModel
    {
        public Guid CustomApplicationId { get; set; }
        public Guid FormId { get; set; }
        public string CompanyIds { get; set; }
    }
}
