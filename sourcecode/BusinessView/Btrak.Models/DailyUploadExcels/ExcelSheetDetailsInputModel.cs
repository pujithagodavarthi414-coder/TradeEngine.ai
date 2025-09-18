using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.DailyUploadExcels
{
    public class ExcelSheetDetailsInputModel
    {
        public string ExcelSheetName { get; set; }
        public string FilePath { get; set; }
        public string MailAddress { get; set; }
        public bool IsHavingErrors { get; set; }
        public bool IsUploaded { get; set; }
        public bool NeedManualCorrection { get; set; }
        public bool UpdateRecord { get; set; }
    }
}
