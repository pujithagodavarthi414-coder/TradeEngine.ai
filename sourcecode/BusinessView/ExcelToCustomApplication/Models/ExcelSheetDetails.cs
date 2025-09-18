using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelToCustomApplication.Models
{
    public class ExcelSheetDetails
    {
        public string ExcelSheetName { get; set; }
        public Guid CompanyId { get; set; }
        public Guid CustomApplicationId { get; set; }
        public Guid FormId { get; set; }
        public string ExcelPath { get; set; }
        public string ExcelSheetErrorFolder { get; set; }
        public string ExcelSheetProcessedFolder { get; set; }
        public string AuthToken { get; set; }
        public Guid CreatedUserId { get; set; }
        public string CreatedUserName { get; set; }
    }
}
