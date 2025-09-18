using Dapper;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ExcelToCustomApplication.Models;

namespace ExcelToCustomApplication.Repositories
{
    public class ExcelToCustomApplicationRepository :BaseRepository
    {
        public List<ExcelSheetDetails> GetExcelSheetDetails()
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    return  vConn.Query<ExcelSheetDetails>("USP_GetExcelSheetDetails", vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                Console.WriteLine(sqlException.Message);
                return null;
            }
        }

        public DailyUploadExcelsOutputModel UpsertExcelToCustomApplicationDetails(DailyUploadExcelsInputModel inputModel)
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
                    vParams.Add("@UpdateRecord", true);
                    vParams.Add("@AuthToken", inputModel.AuthToken);
                    vParams.Add("@CompanyId", inputModel.CompanyId);
                    vParams.Add("@OperationsPerformedBy", inputModel.UserId);
                    return vConn.Query<DailyUploadExcelsOutputModel>("USP_UpsertExcelToCustomApplicationDetails", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                Console.WriteLine(sqlException.Message);
                return null;
            }
        }
    }
}
