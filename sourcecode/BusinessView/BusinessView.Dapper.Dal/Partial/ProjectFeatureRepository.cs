using Btrak.Models.Projects;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ProjectFeatureRepository
    {
        public Guid? UpsertProjectFeature(ProjectFeatureUpsertInputModel projectFeatureUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@FeatureId", projectFeatureUpsertInputModel.ProjectFeatureId);
                    vParams.Add("@FeatureName", projectFeatureUpsertInputModel.ProjectFeatureName);
                    vParams.Add("@FeatureResponsiblePersonId", projectFeatureUpsertInputModel.ProjectFeatureResponsiblePersonId);
                    vParams.Add("@ProjectId", projectFeatureUpsertInputModel.ProjectId);
                    vParams.Add("@IsDelete", projectFeatureUpsertInputModel.IsDelete);
                    vParams.Add("@IsArchived", projectFeatureUpsertInputModel.IsArchived);
                    vParams.Add("@TimeZone", projectFeatureUpsertInputModel.TimeZone);
                    vParams.Add("@TimeStamp", projectFeatureUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertProjectFeature, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectFeature", "ProjectFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionProjectFeatureUpsert);
                return null;
            }
        }

        public List<ProjectFeatureSpReturnModel> GetAllProjectFeaturesByProjectId(ProjectFeatureSearchCriteriaInputModel projectFeatureSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ProjectFeatureId", projectFeatureSearchCriteriaInputModel.ProjectFeatureId);
                    vParams.Add("@ProjectFeatureName", projectFeatureSearchCriteriaInputModel.ProjectFeatureName);
                    vParams.Add("@ProjectFeatureResponsiblePersonId", projectFeatureSearchCriteriaInputModel.ProjectFeatureResponsiblePersonId);
                    vParams.Add("@ProjectId", projectFeatureSearchCriteriaInputModel.ProjectId);
                    vParams.Add("@IsArchived", projectFeatureSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@PageNo", projectFeatureSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", projectFeatureSearchCriteriaInputModel.PageSize);
                    vParams.Add("@IsDelete", projectFeatureSearchCriteriaInputModel.IsDelete);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ProjectFeatureSpReturnModel>(StoredProcedureConstants.SpGetProjectFeatures, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllProjectFeaturesByProjectId", "ProjectFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllProjectFeaturesByProjectId);
                return new List<ProjectFeatureSpReturnModel>();
            }
        }

        public Guid? DeleteProjectFeature(DeleteProjectFeatureModel deleteProjectFeatureModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ProjectFeatureId", deleteProjectFeatureModel.ProjectFeatureId);
                    vParams.Add("@TimeStamp", deleteProjectFeatureModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteProjectFeature, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteProjectFeature", "ProjectFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteProjectFeature);
                return null;
            }
        }

    }
}
