using System;
using System.Text;
using BTrak.Common;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class FormFieldModel 
    {
     
        public Guid? Id { get; set; }
        public Guid? GenericFormId { get; set; }
        public string FormName { get; set; }
        public string Key { get; set; }
        public string Label { get; set; }
        public string DataType { get; set; }
        public Guid? GenericFormKeyId { get; set; }
        public string Path { get; set; }
        public string Type { get; set; }
       
    }
}
