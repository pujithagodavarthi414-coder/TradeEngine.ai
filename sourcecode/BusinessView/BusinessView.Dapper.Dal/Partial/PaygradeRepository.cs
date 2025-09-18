using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class PayGradeRepository
    {
        public Guid? UpsertPayGrade(PayGradeUpsertInputModel payGradeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@PayGradeId", payGradeUpsertInputModel.PayGradeId);
                    vParams.Add("@PayGradeName", payGradeUpsertInputModel.PayGradeName);
                    vParams.Add("@IsArchived", payGradeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", payGradeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPayGrade, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayGrade", "PayGradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertPayGrade);
                return null;
            }
        }

        public List<PayGradeApiReturnModel> GetPayGrades(PayGradeSearchInputModel payGradeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@PayGradeId", payGradeSearchInputModel.PayGradeId);
                    vParams.Add("@SearchText", payGradeSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", payGradeSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<PayGradeApiReturnModel>(StoredProcedureConstants.SpGetPayGrades, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetPayGrades", "PayGradeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetPayGrades);
                return new List<PayGradeApiReturnModel>();
            }
        }
    }
}
