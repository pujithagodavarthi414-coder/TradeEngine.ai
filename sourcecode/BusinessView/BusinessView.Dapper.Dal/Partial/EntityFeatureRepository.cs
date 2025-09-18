using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.EntityType;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class EntityFeatureRepository : BaseRepository
    {
        public List<EntityFeatureApiReturnModel> SearchEntityFeatures(EntityFeatureSearchInputModel entityTypeFeatureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EntityFeatureId", entityTypeFeatureSearchInputModel.EntityFeatureId);
                    vParams.Add("@EntityTypeId", entityTypeFeatureSearchInputModel.EntityTypeId);
                    vParams.Add("@EntityFeatureName", entityTypeFeatureSearchInputModel.EntityFeatureName);
                    vParams.Add("@SearchText", entityTypeFeatureSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", entityTypeFeatureSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EntityFeatureApiReturnModel>(StoredProcedureConstants.SpGetEntityFeatures, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEntityFeatures", "EntityFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchEntityFeatures);
                return new List<EntityFeatureApiReturnModel>();
            }
        }
    }
}
