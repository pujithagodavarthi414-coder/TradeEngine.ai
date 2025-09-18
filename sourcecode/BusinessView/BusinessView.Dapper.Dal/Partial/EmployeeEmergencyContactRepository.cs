
using System;
using System.Data;
using System.Linq;
using Dapper;
using Btrak.Models;
using Btrak.Dapper.Dal.SpModels;
using System.Collections.Generic;
using System.Data.SqlClient;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Currency;
using Btrak.Models.Employee;
using Btrak.Models.HrManagement;
using BTrak.Common;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class EmployeeEmergencyContactRepository : BaseRepository
    {
        public Guid? UpsertEmployeeEmergencyContact(EmployeeEmergencyContactDetailsInputModel employeeEmergencyContactDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeEmergencyContactId", employeeEmergencyContactDetailsInputModel.EmergencyContactId);
                    vParams.Add("@EmployeeId", employeeEmergencyContactDetailsInputModel.EmployeeId);
                    vParams.Add("@RelationshipId", employeeEmergencyContactDetailsInputModel.RelationshipId);
                    vParams.Add("@FirstName", employeeEmergencyContactDetailsInputModel.FirstName);
                    vParams.Add("@LastName", employeeEmergencyContactDetailsInputModel.LastName);
                    vParams.Add("@OtherRelation", employeeEmergencyContactDetailsInputModel.OtherRelation);
                    vParams.Add("@HomeTelephone", employeeEmergencyContactDetailsInputModel.HomeTelephone);
                    vParams.Add("@MobileNo", employeeEmergencyContactDetailsInputModel.MobileNo);
                    vParams.Add("@WorkTelephone", employeeEmergencyContactDetailsInputModel.WorkTelephone);
                    vParams.Add("@IsEmergencyContact", employeeEmergencyContactDetailsInputModel.IsEmergencyContact);
                    vParams.Add("@IsDependentContact", employeeEmergencyContactDetailsInputModel.IsDependentContact);
                    vParams.Add("@AddressStreetOne", employeeEmergencyContactDetailsInputModel.AddressStreetOne);
                    vParams.Add("@AddressStreetTwo", employeeEmergencyContactDetailsInputModel.AddressStreetTwo);
                    vParams.Add("@StateOrProvinceId", employeeEmergencyContactDetailsInputModel.StateOrProvinceId);
                    vParams.Add("@ZipOrPostalCode", employeeEmergencyContactDetailsInputModel.ZipOrPostalCode);
                    vParams.Add("@CountryId", employeeEmergencyContactDetailsInputModel.CountryId);
                    vParams.Add("@TimeStamp", employeeEmergencyContactDetailsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", employeeEmergencyContactDetailsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertEmployeeEmergencyContact, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeEmergencyContact", "EmployeeEmergencyContactRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeeEmergencyContact);
                return null;
            }
        }

        public List<EmployeeEmergencyContactDetailsApiReturnModel> GetEmployeeEmergencyContactDetails(EmployeeDetailSearchCriteriaInputModel employeeDetailSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeDetailSearchCriteriaInputModel.EmployeeId);
                    vParams.Add("@SearchText", employeeDetailSearchCriteriaInputModel.SearchText);
                    vParams.Add("@PageNo", employeeDetailSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeDetailSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SortBy", employeeDetailSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeDetailSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@IsArchived", employeeDetailSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeEmergencyContactDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeEmergencyContactDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeEmergencyContactDetails", "EmployeeEmergencyContactRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeEmergencyContactDetails);
                return new List<EmployeeEmergencyContactDetailsApiReturnModel>();
            }
        }

        public IEnumerable<EmergencyAndDependentContactsSpEntity> GetEmployeeEmergencyAndDependentContactDetailsList(Guid employeeId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                return vConn.Query<EmergencyAndDependentContactsSpEntity>(StoredProcedureConstants.SpEmployeeEmergencyContactSelectAllByEmployeeId, vParams, commandType: CommandType.StoredProcedure)
                   .ToList();
            }
        }

        public bool Delete(Guid id)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", id);

                int iResult = vConn.Execute(StoredProcedureConstants.SpEmployeeEmergencyContactDelete, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        public EmployeeEmergencyAndDependentContactModel GetEmployeeEmergencyAndDependentContactDetails(Guid id)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", id);

                return vConn.Query<EmployeeEmergencyAndDependentContactModel>(StoredProcedureConstants.SpEmployeeEmergencyContactSelect, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public IList<EmployeeEmergencyAndDependentContactModel> GetAllEmergencyList(Guid employeeId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                return vConn.Query<EmployeeEmergencyAndDependentContactModel>(StoredProcedureConstants.SpGetEmergencyContacts, vParams, commandType: CommandType.StoredProcedure)
                     .ToList();
            }
        }

        public IList<EmployeeEmergencyAndDependentContactModel> GetAllDependentList(Guid employeeId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@EmployeeId", employeeId);
                return vConn.Query<EmployeeEmergencyAndDependentContactModel>(StoredProcedureConstants.SpGetDependentContacts, vParams, commandType: CommandType.StoredProcedure)
                     .ToList();
            }
        }

        public List<EmployeeEmergencyContactDetailsApiReturnModel> SearchEmployeeEmergencyContactDetails(EmployeeEmergencyDetailsDetailsInputModel getEmployeeEmergencyDetailsDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", getEmployeeEmergencyDetailsDetailsInputModel.SearchText);
                    vParams.Add("@EmployeeId", getEmployeeEmergencyDetailsDetailsInputModel.EmployeeId);
                    vParams.Add("@EmergencyContactId", getEmployeeEmergencyDetailsDetailsInputModel.EmergencyContactId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeEmergencyContactDetailsApiReturnModel>(StoredProcedureConstants.SpGetEmployeeEmergencyContactDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchEmployeeEmergencyContactDetails", "EmployeeEmergencyContactRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeEmergencyContact);
                return new List<EmployeeEmergencyContactDetailsApiReturnModel>();
            }
        }
    }
}
