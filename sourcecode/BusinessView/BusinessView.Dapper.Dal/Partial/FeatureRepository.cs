using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Features;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class FeatureRepository
    {
        public List<FeatureApiReturnModel> GetAllFeatures(FeatureInputModel featureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FeatureId", featureInputModel.FeatureId);
                    vParams.Add("@FeatureName", featureInputModel.FeatureName);
                    vParams.Add("@IsArchived", featureInputModel.IsArchived);
                    vParams.Add("@ParentFeatureId", featureInputModel.ParentFeatureId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FeatureApiReturnModel>(StoredProcedureConstants.SpGetFeatures, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllFeatures", "FeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllFeatures);
                return new List<FeatureApiReturnModel>();
            }
        }

        public List<UserPermittedFeatureApiRetrnModel> GetAllUserPermittedFeatures(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserPermittedFeatureApiRetrnModel>(StoredProcedureConstants.SpGetAllFeaturesOfAnUser, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUserPermittedFeatures", "FeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUserPermittedFeatures);
                return new List<UserPermittedFeatureApiRetrnModel>();
            }
        }
    }
}
