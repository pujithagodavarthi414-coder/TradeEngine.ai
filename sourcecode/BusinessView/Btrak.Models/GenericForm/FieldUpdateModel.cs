using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class FieldUpdateModel
    {
        public string FormName { get; set; }
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public Guid? FormId { get; set; }
        public Guid? DataSetId { get; set; }
        public Guid? SyncForm { get; set; }
        public int? Type { get; set; }
        public List<InputParamsModel> InputParamSteps { get; set; }

    }

    public class InputParamsModel
    {
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
    }
}
