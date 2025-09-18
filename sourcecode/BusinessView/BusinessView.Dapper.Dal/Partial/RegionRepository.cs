using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.CompanyStructureManagement;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public class RegionRepository : BaseRepository
    {
        public Guid? UpsertRegion(RegionUpsertInputModel regionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@RegionId", regionUpsertInputModel.RegionId);
                    vParams.Add("@RegionName", regionUpsertInputModel.RegionName);
                    vParams.Add("@CountryId", regionUpsertInputModel.CountryId);
                    vParams.Add("@IsArchived", regionUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", regionUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRegion, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRegion", "RegionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertRegion);
                return null;
            }
        }

        public List<RegionApiReturnModel> GetRegions(RegionSearchInputModel regionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@RegionId", regionSearchInputModel.RegionId);
                    vParams.Add("@CountryId", regionSearchInputModel.CountryId);
                    vParams.Add("@SearchText", regionSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", regionSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RegionApiReturnModel>(StoredProcedureConstants.SpGetRegions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRegions", "RegionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRegions);
                return new List<RegionApiReturnModel>();
            }
        }
    }
}