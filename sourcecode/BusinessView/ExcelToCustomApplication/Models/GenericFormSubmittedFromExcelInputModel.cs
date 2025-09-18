using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelToCustomApplication.Models
{
    public class GenericFormSubmittedFromExcelInputModel
    {
        public Guid CustomApplicationId { get; set; }
        public Guid FormId { get; set; } // same as DataSourceId
        public Guid UserId { get; set; }
        public Guid CompanyId { get; set; }
        public List<string> FormJson { get; set; }
        public string ExcelSheetName { get; set; }
        public Guid GenericFormSubmittedId { get; set; }
    }
}
