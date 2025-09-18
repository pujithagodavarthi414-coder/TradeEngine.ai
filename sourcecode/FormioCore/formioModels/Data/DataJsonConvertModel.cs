using System.Collections.Generic;

namespace formioModels.Data
{
    public class Component
    {
        public string Label { get; set; }
        public string Title { get; set; }
        public string Type { get; set; }
        public bool Input { get; set; }
        public string Key { get; set; }
        public string Placeholder { get; set; }
        public object DefaultValue { get; set; }
        public string Description { get; set; }
        public string Tooltip { get; set; }
        public string html { get; set; }
        public string content { get; set; }
        public List<Component> Columns { get; set; }
        public object Rows { get; set; }
        public string[] UserView { get; set; }
        public string[] UserEdit { get; set; }
        public string[] RoleView { get; set; }
        public string[] RoleEdit { get; set; }
        public string[] RelatedFieldsLabel { get; set; }
        public string GenricFormName { get; set; }
        public string FormName { get; set; }
        public string[] Relatedfield { get; set; }
        public string FieldName { get; set; }
        public string SelectedFormName { get; set; }
        public object RelatedFieldsfinalData { get; set; }
        public string ConcatSplitKey { get; set; }
        public string[] ConcateFormFields { get; set; }
        public string DateTimeForLinkedFields { get; set; }
        public string DataType { get; set; }
        public List<Component> Components { get; set; }
    }
    public class DataJsonConvertModel
    {
        public List<Component> Components { get; set; }
    }

}
