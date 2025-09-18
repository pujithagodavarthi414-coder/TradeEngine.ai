using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class FormKeyModel
    {
        public string Label { get; set; }
        public string Title { get; set; }
        public string Type { get; set; }
        public bool? Input { get; set; }
        public string Key { get; set; }
        public string Placeholder { get; set; }
        public dynamic DefaultValue { get; set; }
        public string Description { get; set; }
        public string Tooltip { get; set; }
        public dynamic Columns { get; set; }
        public dynamic Rows { get; set; }
        public dynamic ViewPermissions { get; set; }
        public dynamic EditPermissions { get; set; }
        public dynamic DataType { get; set; }
        public dynamic Components { get; set; }
    }
}
