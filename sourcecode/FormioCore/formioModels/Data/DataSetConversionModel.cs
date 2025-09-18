using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioModels.Data
{
    public class DataSetConversionModel
    {
        public DataSetOutputModel Data { get; set; }
        public int? TotalCount { get; set; }
    }
    public class DataSetConversionModelForFormFields
    {
        public object Data { get; set; }
        public int? TotalCount { get; set; }
    }

    public class DataSetConversionModelForForms
    {
        public DataSetOutputModelForForms Data { get; set; }
        public int? TotalCount { get; set; }
    }
}
