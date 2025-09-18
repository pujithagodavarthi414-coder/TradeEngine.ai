using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.ButtonType;
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
    public partial class ButtonTypeRepository
    {
        public Guid? UpsertButtonType(ButtonTypeInputModel buttonTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ButtonTypeName", buttonTypeInputModel.ButtonTypeName);
                    vParams.Add("@ButtonTypeId", buttonTypeInputModel.ButtonTypeId);
                    vParams.Add("@ShortName", buttonTypeInputModel.shortName);
                    vParams.Add("@IsArchived", buttonTypeInputModel.IsArchived);
                    vParams.Add("@TimeStamp", buttonTypeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertButtonType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertButtonType", " ButtonTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionButtonTypeUpsert);

                return null;
            }
        }

        public List<ButtonTypeOutputModel> GetAllButtonTypes(ButtonTypeInputModel buttonTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ButtonTypeId", buttonTypeInputModel.ButtonTypeId);
                    vParams.Add("@ButtonTypeName", buttonTypeInputModel.ButtonTypeName);
                    vParams.Add("@SearchText", buttonTypeInputModel.SearchText);
                    vParams.Add("@IsArchived", buttonTypeInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DeviceId", buttonTypeInputModel.DeviceId);
                    return vConn.Query<ButtonTypeOutputModel>(StoredProcedureConstants.SpGetButtonTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllButtonTypes", " ButtonTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllButtonTypes);

                return new List<ButtonTypeOutputModel>();
            }
        }

        public ButtonTypeByIdOutputModel GetButtonTypeById(Guid? buttonTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ButtonTypeId", buttonTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ButtonTypeByIdOutputModel>(StoredProcedureConstants.SPGetButtonTypeById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetButtonTypeById", " ButtonTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllButtonTypes);

                return null;
            }
        }
    }
}
