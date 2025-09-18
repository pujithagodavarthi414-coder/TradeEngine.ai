using BTrak.Common;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.HrManagement;
using Btrak.Models;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Models.DailyUploadExcels;
using Btrak.Models.Widgets;

namespace Btrak.Dapper.Dal.Partial
{
    public partial class ExcelToCustomApplicationRepository : BaseRepository
    {
        public DailyUploadExcelsOutputModel UpsertExcelToCustomApplicationDetails(DailyUploadExcelsInputModel inputModel,bool updateRecord, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ExcelSheetName", inputModel.ExcelSheetName);
                    vParams.Add("@ExcelPath", inputModel.FilePath);
                    vParams.Add("@MailAddress", inputModel.MailAddress);
                    vParams.Add("@IsUploaded", inputModel.IsUploaded);
                    vParams.Add("@CustomApplicationId", inputModel.CustomApplicationId);
                    vParams.Add("@FormId", inputModel.FormId);
                    vParams.Add("@IsHavingErrors", inputModel.IsHavingErrors);
                    vParams.Add("@NeedManualCorrection", inputModel.NeedManualCorrection);
                    vParams.Add("@ErrorText", inputModel.ErrorText);
                    vParams.Add("@UpdateRecord", updateRecord);
                    vParams.Add("@AuthToken", inputModel.AuthToken);
                    vParams.Add("@CompanyId", inputModel.CompanyId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DailyUploadExcelsOutputModel>(StoredProcedureConstants.SpUpsertExcelToCustomApplicationDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExcelToCustomApplicationDetails", "ExcelToCustomApplicationRepository ", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "Can not upsert excel to custom application details");
                return null;
            }
        }

        public List<ExcelToCustomApplicationRecordsDetailsModel> GetExcelToCustomApplicationsDetails(ExcelToCustomApplicationsDetailsSearchModel searchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@IsUploaded", searchModel.IsUploaded);
                    vParams.Add("@IsHavingErrors", searchModel.IsHavingErrors);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ExcelToCustomApplicationRecordsDetailsModel>(StoredProcedureConstants.SpGetExcelToCustomApplicationsDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetExcelToCustomApplicationsDetails", "ExcelToCustomApplicationRepository ", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "Can not get Excel to custom applications details");
                return null;
            }
        }

        public List<EmailsReaderDetailsModel> GetDetailsForEmailsReader(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenAuthConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmailsReaderDetailsModel>(StoredProcedureConstants.SpGetDetailsForEmailsReader, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "Can not get details for email reader");
                return null;
            }
        }


    }
}
