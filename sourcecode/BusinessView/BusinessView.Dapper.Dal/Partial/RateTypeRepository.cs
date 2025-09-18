using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Currency;
using Btrak.Models.RateType;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class RateTypeRepository : BaseRepository
    {
        public Guid? UpsertRateType(RateTypeInputModel rateTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RatetypeId", rateTypeInputModel.RateTypeId);
                    vParams.Add("@TypeName", rateTypeInputModel.TypeName);
                    vParams.Add("@Rate", rateTypeInputModel.Rate);
                    vParams.Add("@IsArchived", rateTypeInputModel.IsArchive);
                    vParams.Add("@TimeStamp", rateTypeInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRatetype, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRateType", "RateTypeRepository", sqlException.Message),sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionRateType);
                return null;
            }
        }

        public List<RateTypeOutputModel> SearchRateType(RateTypeSearchCriteriaInputModel rateTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RatetypeId", rateTypeSearchCriteriaInputModel.RateTypeId);
                    vParams.Add("@TypeName", rateTypeSearchCriteriaInputModel.TypeName);
                    vParams.Add("@SearchText", rateTypeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@Rate", rateTypeSearchCriteriaInputModel.Rate);
                    vParams.Add("@IsArchived", rateTypeSearchCriteriaInputModel.IsArchive);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RateTypeOutputModel>(StoredProcedureConstants.SpGetRateTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchRateType", "RateTypeRepository", sqlException.Message),sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchRateType);
                return new List<RateTypeOutputModel>();
            }
        }
    }
}
