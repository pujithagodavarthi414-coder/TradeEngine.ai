using BTrak.Common;
using Btrak.Models.DailyUploadExcels;
using Btrak.Models;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.EmailReader.Repositories
{
    public class ExcelRepository : BaseRepository
    {
        public ExcelRepository()
        {

        }

        public List<EmailsReaderDetailsModel> GetDetailsForEmailsReader(List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenAuthConnection())
                {
                    var vParams = new DynamicParameters();
                    return vConn.Query<EmailsReaderDetailsModel>(StoredProcedureConstants.SpGetDetailsForEmailsReader, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                return null;
            }
        }

        public DailyUploadExcelsOutputModel UpsertExcelToCustomApplicationDetails(DailyUploadExcelsInputModel inputModel, bool updateRecord, Guid userId, List<ValidationMessage> validationMessages)
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
                    vParams.Add("@OperationsPerformedBy", userId);
                    return vConn.Query<DailyUploadExcelsOutputModel>(StoredProcedureConstants.SpUpsertExcelToCustomApplicationDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                //SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "Can not upsert excel to custom application details");
                return null;
            }
        }

    }
}
