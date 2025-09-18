using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class FormFieldValuesOuputModel
    {
        public string Key { get; set; }
        public string Type { get; set; }
        public int? DecimalLimit { get; set; }
        public string Format { get; set; }
        public bool? Delimiter { get; set; }
        public bool? RequireDecimal { get; set; }
        public object FieldValues { get; set; }
    }
}
