using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.CompanyLocation;
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
    public class CompanyLocationRepository : BaseRepository
    {
        public Guid? UpsertCompanyLocation(CompanyLocationInputModel companyLocationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyLocationId", companyLocationInputModel.CompanyLocationId);
                    vParams.Add("@LocationName", companyLocationInputModel.LocationName);
                    vParams.Add("@Address", companyLocationInputModel.Address);
                    vParams.Add("@Latitude", companyLocationInputModel.Latitude);
                    vParams.Add("@Longitude", companyLocationInputModel.Longitude);
                    vParams.Add("@IsArchived", companyLocationInputModel.IsArchived);
                    vParams.Add("@TimeStamp", companyLocationInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCompanyLocation, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCompanyLocation", " CompanyLocationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompanyLocation);
                return null;
            }
        }

        public List<CompanyLocationOutputModel> SearchCompanyLocation(CompanyLocationInputSearchCriteriaModel companyLocationInputSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@CompanyLocationId", companyLocationInputSearchCriteriaModel.CompanyLocationId);
                    vParams.Add("@LocationName", companyLocationInputSearchCriteriaModel.LocationName);
                    vParams.Add("@Address", companyLocationInputSearchCriteriaModel.Address);
                    vParams.Add("@Latitude", companyLocationInputSearchCriteriaModel.Latitude);
                    vParams.Add("@Longitude", companyLocationInputSearchCriteriaModel.Longitude);
                    vParams.Add("@SearchText", companyLocationInputSearchCriteriaModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsArchived", companyLocationInputSearchCriteriaModel.IsArchived);
                    return vConn.Query<CompanyLocationOutputModel>(StoredProcedureConstants.SpSearchCompanyLocations, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchCompanyLocation", " CompanyLocationRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchCompanyLocation);
                return new List<CompanyLocationOutputModel>();
            }
        }
    }
}
