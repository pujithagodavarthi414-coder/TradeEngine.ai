using Btrak.Models;
using Btrak.Models.DailyUploadExcels;
using Btrak.Models.HrManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.ExcelToCustomApplicationRecords
{
    public interface IDailyUploadExcelService
    {
        DailyUploadExcelsOutputModel UpsertExcelToCustomApplicationDetails(DailyUploadExcelsInputModel inputModel,bool updateRecord, LoggedInContext loggedInContext , List<ValidationMessage> validationMessages);
        List<ExcelToCustomApplicationRecordsDetailsModel> GetExcelToCustomApplicationsDetails(ExcelToCustomApplicationsDetailsSearchModel searchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmailsReaderDetailsModel> GetDetailsForEmailsReader(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
