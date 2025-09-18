using BTrak.Common;
using Btrak.Models.DailyUploadExcels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models.GenericForm;
using Btrak.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.HrManagement;

namespace Btrak.Services.ExcelToCustomApplicationRecords
{
    public class DailyUploadExcelService : IDailyUploadExcelService
    {
        private readonly ExcelToCustomApplicationRepository _dailyUploadExcelRepository;

        public DailyUploadExcelService(ExcelToCustomApplicationRepository dailyUploadExcelRepository) {
            _dailyUploadExcelRepository = dailyUploadExcelRepository;
        }

        public DailyUploadExcelsOutputModel UpsertExcelToCustomApplicationDetails(DailyUploadExcelsInputModel inputModel, bool updateRecord, LoggedInContext loggedInContext , List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertExcelToCustomApplicationDetails", "DailyUploadExcelService"));
                DailyUploadExcelsOutputModel dailyUploadExcelsDetails = _dailyUploadExcelRepository.UpsertExcelToCustomApplicationDetails(inputModel, updateRecord, loggedInContext, validationMessages);
                return dailyUploadExcelsDetails;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExcelToCustomApplicationDetails", "DailyUploadExcelService", exception.Message), exception);
                return null;
            }
        }

        public List<ExcelToCustomApplicationRecordsDetailsModel> GetExcelToCustomApplicationsDetails(ExcelToCustomApplicationsDetailsSearchModel searchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetExcelToCustomApplicationsDetails", "DailyUploadExcelService"));
                List<ExcelToCustomApplicationRecordsDetailsModel> excelDetails = _dailyUploadExcelRepository.GetExcelToCustomApplicationsDetails(searchModel,  loggedInContext , validationMessages);
                return excelDetails;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExcelToCustomApplicationsDetails", "DailyUploadExcelService", exception.Message), exception);
                return null;
            }
        }

        public List<EmailsReaderDetailsModel> GetDetailsForEmailsReader(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDetailsForEmailsReader", "DailyUploadExcelService"));
                List<EmailsReaderDetailsModel> emailReaderDetails = _dailyUploadExcelRepository.GetDetailsForEmailsReader(loggedInContext, validationMessages);
                return emailReaderDetails;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDetailsForEmailsReader", "DailyUploadExcelService", exception.Message), exception);
                return null;
            }
        }


    }
}
