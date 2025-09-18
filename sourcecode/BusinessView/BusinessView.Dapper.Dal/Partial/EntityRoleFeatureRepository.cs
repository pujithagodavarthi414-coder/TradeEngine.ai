using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.EntityRole;
using Btrak.Models.EntityType;
using Btrak.Models.Role;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class EntityRoleFeatureRepository : BaseRepository
    {
        public Guid? UpsertEntityRoleFeature(EntityRoleFeatureUpsertInputModel entityRoleFeatureUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EntityFeatureIdXml", entityRoleFeatureUpsertInputModel.EntityFeatureIdXml);
                    vParams.Add("@EntityRoleId", entityRoleFeatureUpsertInputModel.EntityRoleId);
                    vParams.Add("@IsArchived", entityRoleFeatureUpsertInputModel.IsArchived);
                    //vParams.Add("@TimeStamp", entityRoleFeatureUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEntityRoleFeature, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEntityRoleFeature", "EntityRoleFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEntityRoleFeatureUpsert);
                return null;
            }
        }

        public List<EntityRoleFeatureApiReturnModel> SearchEntityRoleFeatures(EntityRoleFeatureSearchInputModel entityTypeRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityRoleFeatureId", entityTypeRoleFeatureSearchInputModel.EntityRoleFeatureId);
                    vParams.Add("@EntityFeatureId", entityTypeRoleFeatureSearchInputModel.EntityFeatureId);
                    vParams.Add("@EntityFeatureName", entityTypeRoleFeatureSearchInputModel.EntityFeatureName);
                    vParams.Add("@EntityRoleId", entityTypeRoleFeatureSearchInputModel.EntityRoleId);
                    vParams.Add("@EntityRoleName", entityTypeRoleFeatureSearchInputModel.EntityRoleName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectId", entityTypeRoleFeatureSearchInputModel.ProjectId);
                    vParams.Add("@IsArchived", entityTypeRoleFeatureSearchInputModel.IsArchived);
                    return vConn.Query<EntityRoleFeatureApiReturnModel>(StoredProcedureConstants.SpGetEntityRoleFeatures, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEntityRoleFeatures", "EntityRoleFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchEntityRoleFeatures);
                return new List<EntityRoleFeatureApiReturnModel>();
            }
        }

        public List<EntityRoleFeatureApiReturnModel> SearchEntityRoleFeaturesByUserId(EntityRoleFeatureSearchInputModel entityTypeRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityRoleId", entityTypeRoleFeatureSearchInputModel.EntityRoleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@ProjectId", entityTypeRoleFeatureSearchInputModel.ProjectId);
                    return vConn.Query<EntityRoleFeatureApiReturnModel>(StoredProcedureConstants.SpGetEntityRoleFeaturesByUserId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEntityRoleFeaturesByUserId", "EntityRoleFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchEntityRoleFeatures);
                return new List<EntityRoleFeatureApiReturnModel>();
            }
        }

        public List<EntityRolesWithFeaturesApiReturnModel> GetEntityRolesWithFeatures(EntityRoleFeatureSearchInputModel entityTypeRoleFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityRoleId", entityTypeRoleFeatureSearchInputModel.EntityRoleId);
                    vParams.Add("@EntityRoleName", entityTypeRoleFeatureSearchInputModel.EntityRoleName);
                    vParams.Add("@IsArchived", entityTypeRoleFeatureSearchInputModel.IsArchived);
                    vParams.Add("@SearchText", entityTypeRoleFeatureSearchInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EntityRolesWithFeaturesApiReturnModel>(StoredProcedureConstants.SpGetEntityRolesWithFeatures, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntityRolesWithFeatures", "EntityRoleFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchEntityRoleFeatures);
                return new List<EntityRolesWithFeaturesApiReturnModel>();
            }
        }

        public List<EntityRoleFeatureOutputModel> GetEntityRolesByEntityFeatureId(Guid? entityFeatureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityFeatureId", entityFeatureId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EntityRoleFeatureOutputModel>(StoredProcedureConstants.SpGetEntityRoleByEntityFeatureId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEntityRolesByEntityFeatureId", "EntityRoleFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllRoles);
                return new List<EntityRoleFeatureOutputModel>();
            }
        }

        public Guid? UpdateEntityRoleFeature(UpdateEntityFeature updateEntityFeature, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityRoleId", updateEntityFeature.EntityRoleId);
                    vParams.Add("@EntityFeatureId", updateEntityFeature.EntityFeatureId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateEntityRoleFeature, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateEntityRoleFeature", "EntityRoleFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllRoles);
                return null;
            }

        }
    }
}
