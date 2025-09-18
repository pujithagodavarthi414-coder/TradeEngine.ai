using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class RelationshipRepository : BaseRepository
    {
        public Guid? UpsertRelstionship(RelationshipUpsertModel relationshipUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@RelationShipId", relationshipUpsertModel.RelationshipId);
                    vParams.Add("@RelationShipName", relationshipUpsertModel.RelationshipName);
                    vParams.Add("@IsArchived", relationshipUpsertModel.IsArchived);
                    vParams.Add("@TimeStamp", relationshipUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRelationship, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRelstionship", "RelationshipRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertRelstionship);
                return null;
            }
        }

        public List<RelationShipTypeSearchCriteriaInputModel> SearchRealtionShip(RelationShipTypeSearchCriteriaInputModel relationShipTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RelationShipId", relationShipTypeSearchCriteriaInputModel.RelationshipId);
                    vParams.Add("@RelationShipName", relationShipTypeSearchCriteriaInputModel.RelationshipName);
                    vParams.Add("@SearchText", relationShipTypeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", relationShipTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RelationShipTypeSearchCriteriaInputModel>(StoredProcedureConstants.SpGetRelationship, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchRealtionShip", "RelationshipRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchRateType);
                return new List<RelationShipTypeSearchCriteriaInputModel>();
            }
        }

        public List<EmployeeDependentContactModel> SearchEmployeeDependentContacts(EmployeeDependentContactSearchInputModel EmployeeDependentContactSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", EmployeeDependentContactSearchInputModel.EmployeeId);
                    vParams.Add("@RelationshipId", EmployeeDependentContactSearchInputModel.RelationshipId);
                    vParams.Add("@FirstName", EmployeeDependentContactSearchInputModel.FirstName);
                    vParams.Add("@LastName", EmployeeDependentContactSearchInputModel.LastName);
                    vParams.Add("@OtherRelation", EmployeeDependentContactSearchInputModel.OtherRelation);
                    vParams.Add("@HomeTelephone", EmployeeDependentContactSearchInputModel.HomeTelephone);
                    vParams.Add("@MobileNo", EmployeeDependentContactSearchInputModel.MobileNo);
                    vParams.Add("@WorkTelephone", EmployeeDependentContactSearchInputModel.WorkTelephone);
                    vParams.Add("@IsEmergencyContact", EmployeeDependentContactSearchInputModel.IsEmergencyContact);
                    vParams.Add("@IsDependentContact", EmployeeDependentContactSearchInputModel.IsDependentContact);
                    vParams.Add("@AddressStreetOne", EmployeeDependentContactSearchInputModel.AddressStreetOne);
                    vParams.Add("@AddressStreetTwo", EmployeeDependentContactSearchInputModel.AddressStreetTwo);
                    vParams.Add("@StateOrProvinceId", EmployeeDependentContactSearchInputModel.StateOrProvinceId);
                    vParams.Add("@ZipOrPostalCode", EmployeeDependentContactSearchInputModel.ZipOrPostalCode);
                    vParams.Add("@CountryId", EmployeeDependentContactSearchInputModel.CountryId);
                    vParams.Add("@OriginalId", EmployeeDependentContactSearchInputModel.EmployeeDependentId);
                    vParams.Add("@SearchText", EmployeeDependentContactSearchInputModel.SearchText);
                    vParams.Add("@IsArchived", EmployeeDependentContactSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SortBy", EmployeeDependentContactSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", EmployeeDependentContactSearchInputModel.SortDirection);
                    vParams.Add("@PageNumber", EmployeeDependentContactSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", EmployeeDependentContactSearchInputModel.PageSize);
                    return vConn.Query<EmployeeDependentContactModel>(StoredProcedureConstants.SpGetEmployeeDependentContacts, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeDependentContacts", "RelationshipRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchEmployeeDependentContacts);
                return new List<EmployeeDependentContactModel>();
            }
        }
    }
}