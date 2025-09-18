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
    public class CountryRepository: BaseRepository
    {
        public Guid? UpsertCountry(CountryUpsertInputModel countryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@CountryId", countryUpsertInputModel.CountryId);
                    vParams.Add("@CountryName", countryUpsertInputModel.CountryName);
                    vParams.Add("@CountryCode", countryUpsertInputModel.CountryCode);
                    vParams.Add("@IsArchived", countryUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", countryUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertCountry, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCountry", "CountryRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCountry);
                return null;
            }
        }

        public List<CountryApiReturnModel> GetCountries(CountrySearchInputModel countrySearchInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@IsArchived", countrySearchInputModel.IsArchived);
                    vParams.Add("@CountryId", countrySearchInputModel.CountryId);
                    vParams.Add("@SearchText", countrySearchInputModel.SearchText);
                    vParams.Add("@CountryName", countrySearchInputModel.CountryName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CountryApiReturnModel>(StoredProcedureConstants.SpGetCountries, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCountries", "CountryRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCountries);
                return new List<CountryApiReturnModel>();
            }
        }

        public List<CompanyStructureSpReturnModel> GetCompanyStructure(CompanyStructureSearchInputModel companyStructureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@CountryId", companyStructureSearchInputModel.CountryId);
                    vParams.Add("@BranchId", companyStructureSearchInputModel.BranchId);
                    vParams.Add("@RegionId", companyStructureSearchInputModel.RegionId);
                    vParams.Add("@CountryNameSearchText", companyStructureSearchInputModel.CountryNameSearchText);
                    vParams.Add("@RegionNameSearchText", companyStructureSearchInputModel.RegionNameSearchText);
                    vParams.Add("@BranchNameSearchText", companyStructureSearchInputModel.BranchNameSearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<CompanyStructureSpReturnModel>(StoredProcedureConstants.SpGetCompanyStructure, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCompanyStructure", "CountryRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetCompanyStructure);
                return new List<CompanyStructureSpReturnModel>();
            }
        }
    }
}
