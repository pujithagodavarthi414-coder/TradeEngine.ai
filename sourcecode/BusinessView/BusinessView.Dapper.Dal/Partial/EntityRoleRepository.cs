using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models.EntityRole;

namespace Btrak.Dapper.Dal.Repositories
{
    public class EntityRoleRepository : BaseRepository
    {
        public Guid? UpsertEntityRole(EntityRoleInputModel entityRoleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityRoleId", entityRoleInputModel.EntityRoleId);
                    vParams.Add("@EntityRoleName", entityRoleInputModel.EntityRoleName);
                    vParams.Add("@IsArchived", entityRoleInputModel.IsArchived);
                    vParams.Add("@TimeStamp", entityRoleInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEntityRole, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEntityRole", "EntityRoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEntityRole);
                return null;
            }
        }

        public Guid? DeleteEntityRole(EntityRoleInputModel entityRoleInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityRoleId", entityRoleInputModel.EntityRoleId);
                    vParams.Add("@IsArchived", entityRoleInputModel.IsArchived);
                    vParams.Add("@TimeStamp", entityRoleInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteEntityRole, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteEntityRole", "EntityRoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteEntityRole);
                return null;
            }
        }

        public List<EntityRoleOutputModel> GetEntityRole(EntityRoleSearchCriteriaInputModel entityRoleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityRoleId", entityRoleSearchCriteriaInputModel.EntityRoleId);
                    vParams.Add("@EntityRoleName", entityRoleSearchCriteriaInputModel.EntityRoleName);
                    vParams.Add("@SearchText", entityRoleSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", entityRoleSearchCriteriaInputModel.IsActive);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EntityRoleOutputModel>(StoredProcedureConstants.SpGetEntityRole, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntityRole", "EntityRoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.GetEntityRole);
                return new List<EntityRoleOutputModel>();
            }
        }
    }
}
