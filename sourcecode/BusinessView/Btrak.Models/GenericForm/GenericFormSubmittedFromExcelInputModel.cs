using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.GenericForm
{
    public class GenericFormSubmittedFromExcelInputModel
    {
        public Guid? GenericFormSubmittedId { get; set; }
        public Guid? DataSetId { get; set; } // same as GenericFormSubmittedId
        public Guid? CustomApplicationId { get; set; }
        public Guid? DataSourceId { get; set; }
        public Guid? FormId { get; set; } // same as DataSourceId
        public List<string> FormJson { get; set; }
        public string ExcelSheetName { get; set; }

    }
}
