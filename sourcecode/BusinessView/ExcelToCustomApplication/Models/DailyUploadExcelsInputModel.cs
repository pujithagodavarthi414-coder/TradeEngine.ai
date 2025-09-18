using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExcelToCustomApplication.Models
{
    public class DailyUploadExcelsInputModel
    {
        public string ExcelSheetName { get; set; }
        public bool IsUploaded { get; set; }
        public Guid? CustomApplicationId { get; set; }
        public Guid? FormId { get; set; }
        public bool IsHavingErrors { get; set; }
        public bool NeedManualCorrection { get; set; }
        public string ErrorText { get; set; }
        public string MailAddress { get; set; }
        public string FilePath { get; set; }
        public string AuthToken { get; set; }
        public Guid CompanyId { get; set; }
        public Guid UserId { get; set; }
    }
}
