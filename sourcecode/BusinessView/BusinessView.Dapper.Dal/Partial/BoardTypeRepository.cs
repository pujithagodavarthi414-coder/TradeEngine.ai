using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.BoardType;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class BoardTypeRepository
    {
        public Guid? UpsertBoardType(BoardTypeUpsertInputModel boardTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BoardTypeId", boardTypeUpsertInputModel.BoardTypeId);
                    vParams.Add("@BoardTypeName", boardTypeUpsertInputModel.BoardTypeName);
                    vParams.Add("@BoardTypeUIId", boardTypeUpsertInputModel.BoardTypeUiId);
                    vParams.Add("@IsArchived", boardTypeUpsertInputModel.IsArchived);
                    vParams.Add("@TimeZone", boardTypeUpsertInputModel.TimeZone);
                    vParams.Add("@IsBugBoard", boardTypeUpsertInputModel.IsBugBoard);
                    vParams.Add("@IsSuperAgileBoard", boardTypeUpsertInputModel.IsSuperAgileBoard);
                    vParams.Add("@IsDefault", boardTypeUpsertInputModel.IsDefault);
                    vParams.Add("@IsApi", boardTypeUpsertInputModel.IsApi);
                    vParams.Add("@TimeStamp", boardTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpGetUpsertBoardType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBoardType", "BoardTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionBoardTypeUpsert);
                return null;
            }
        }

        public List<BoardTypeApiReturnModel> GetAllBoardTypes(BoardTypeInputModel boardTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@BoardTypeUIId", boardTypeInputModel.BoardTypeUiId);
                    vParams.Add("@BoardTypeId", boardTypeInputModel.BoardTypeId);
                    vParams.Add("@BoardTypeName", boardTypeInputModel.BoardTypeName);
                    vParams.Add("@IsArchived", boardTypeInputModel.IsArchived);
                    return vConn.Query<BoardTypeApiReturnModel>(StoredProcedureConstants.SpGetBoardTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllBoardTypes", "BoardTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllBoardType);
                return new List<BoardTypeApiReturnModel>();
            }
        }

        public Guid? UpsertBoardTypeWorkFlow(BoardTypeWorkFlowUpsertInputModel boardTypeWorkFlowUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BoardTypeWorkFlowId", boardTypeWorkFlowUpsertInputModel.BoardTypeWorkFlowId);
                    vParams.Add("@BoardTypeId", boardTypeWorkFlowUpsertInputModel.BoardTypeId);
                    vParams.Add("@WorkFlowId", boardTypeWorkFlowUpsertInputModel.WorkFlowId);
                    vParams.Add("@IsArchived", boardTypeWorkFlowUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", boardTypeWorkFlowUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertBoardTypeWorkFlow, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertBoardTypeWorkFlow", "BoardTypeRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionBoardTypeWorkFlow);
                return null;
            }
        }
    }
}
