using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
   public class GetFormRecordValuesInputModel
    {
        public Guid? FormId { get; set; }
        public List<Guid?> FormIds { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public string KeyName { get; set; }
        public string KeyValue { get; set; }
        public string FormName { get; set; }
        public string CustomApplicationName { get; set; }
        public List<string> FieldNames { get; set; }
        public string FieldsXML { get; set; }
        public string FormsXML { get; set; }
        public string FormIdsXML { get; set; }
        public List<FormsMiniModel> FormsModel { get; set; }
        public int? PageSize { get; set; }
        public string CompanyIds { get; set; }
        public bool? IsForRq { get; set; }
    }

    public class GetFormsWithFieldInputModel
    {
        public Guid? FormId { get; set; }
        public string KeyName { get; set; }

    }
}
