using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.BoardType;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class BoardTypeApiRepository
    {
        public Guid? UpsertBoardTypeApi(BoardTypeApiUpsertInputModel boardTypeApiUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BoardTypeApiId", boardTypeApiUpsertInputModel.BoardTypeApiId);
                    vParams.Add("@ApiName", boardTypeApiUpsertInputModel.ApiName);
                    vParams.Add("@ApiUrl", boardTypeApiUpsertInputModel.ApiUrl);
                    vParams.Add("@IsArchived", boardTypeApiUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", boardTypeApiUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBoardTypeApi, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBoardTypeApi", " BoardTypeApiRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionBoardTypeApiUpsert);
                return null;
            }
        }

        public List<BoardTypeApiApiReturnModel> GetAllBoardTypeApis(BoardTypeApiInputModel boardTypeApiInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BoardTypeApiId", boardTypeApiInputModel.BoardTypeApiId);
                    vParams.Add("@ApiName", boardTypeApiInputModel.ApiName);
                    vParams.Add("@IsArchived", boardTypeApiInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<BoardTypeApiApiReturnModel>(StoredProcedureConstants.SpGetBoardTypeApis, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBoardTypeApis", " BoardTypeApiRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetBoardTypeApiById);
                return new List<BoardTypeApiApiReturnModel>();
            }
        }
    }
}
