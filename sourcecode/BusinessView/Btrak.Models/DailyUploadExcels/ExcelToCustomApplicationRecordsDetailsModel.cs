using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.DailyUploadExcels
{
    public class ExcelToCustomApplicationRecordsDetailsModel
    {
        public string ExcelSheetName { get; set; }
        public string UploaderName { get; set; }
        public string UploadedDateTime { get; set; }
    }
}
