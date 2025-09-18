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
    public partial class BreakTypeRepository
    {
        public Guid? UpsertBreakType(BreakTypeUpsertInputModel breakTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@BreakId", breakTypeUpsertInputModel.BreakId);
                    vParams.Add("@BreakTypeName", breakTypeUpsertInputModel.BreakTypeName);
                    vParams.Add("@IsPaid", breakTypeUpsertInputModel.IsPaid);
                    vParams.Add("@IsArchived", breakTypeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", breakTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBreakType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBreakType", "BreakTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertBreakType);
                return null;
            }
        }

        public List<BreakTypeSpReturnModel> GetBreakTypes(BreakTypeSearchInputModel breakTypeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@BreakTypeId", breakTypeSearchInputModel.BreakTypeId);
                    vParams.Add("@BreakTypeName", breakTypeSearchInputModel.BreakTypeName);
                    vParams.Add("@SearchText", breakTypeSearchInputModel.SearchText);
                    vParams.Add("@IsPaid", breakTypeSearchInputModel.IsPaid);
                    vParams.Add("@IsArchived", breakTypeSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BreakTypeSpReturnModel>(StoredProcedureConstants.SpGetBreakTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetBreakTypes", "BreakTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBreakTypes);
                return new List<BreakTypeSpReturnModel>();
            }
        }
    }
}
