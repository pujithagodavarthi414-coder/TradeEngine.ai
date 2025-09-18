using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Supplier;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class SupplierRepository
    {
        public List<SupplierDetailsOutputModel> SearchSupplier(SupplierSearchCriteriaInputModel supplierSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Pagesize", supplierSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SupplierId", supplierSearchCriteriaInputModel.SupplierId);
                    vParams.Add("@SearchText", supplierSearchCriteriaInputModel.SearchText);
                    vParams.Add("@Pagenumber", supplierSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@SortBy", supplierSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", supplierSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@IsArchived", supplierSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<SupplierDetailsOutputModel>(StoredProcedureConstants.SpSearchSuppliers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSupplier", "SupplierRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchSupplier);
                return new List<SupplierDetailsOutputModel>();
            }
        }

        public Guid? UpsertSupplier(SupplierDetailsInputModel supplierInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SupplierId", supplierInputModel.SupplierId);
                    vParams.Add("@SupplierName", supplierInputModel.SupplierName);
                    vParams.Add("@SupplierCompanyName", supplierInputModel.SupplierCompanyName);
                    vParams.Add("@ContactPerson", supplierInputModel.ContactPerson);
                    vParams.Add("@ContactPosition", supplierInputModel.ContactPosition);
                    vParams.Add("@CompanyPhoneNumber", supplierInputModel.CompanyPhoneNumber);
                    vParams.Add("@ContactPhoneNumber", supplierInputModel.ContactPhoneNumber);
                    vParams.Add("@VendorIntroducedBy", supplierInputModel.VendorIntroducedBy);
                    vParams.Add("@StartedWorkingFrom", supplierInputModel.StartedWorkingFrom);
                    vParams.Add("@TimeStamp", supplierInputModel.TimeStamp,DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId); 
                    vParams.Add("@IsArchived", supplierInputModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSuppliers, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSupplier", "SupplierRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSupplierUpsert);
                return null;
            }
        }

        public List<SupplierDetailsOutputModel> GetAllSuppliers(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@SearchText", searchText);
                    return vConn.Query<SupplierDetailsOutputModel>(StoredProcedureConstants.SpGetAllSuppliers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllSuppliers", "SupplierRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchSupplier);
                return new List<SupplierDetailsOutputModel>();
            }
        }

        public List<SuppliersDropDownOutputModel> GetSuppliersDropDown(String searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SuppliersDropDownOutputModel>(StoredProcedureConstants.SpGetSuppliersDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSuppliersDropDown", "SupplierRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllSuppliersDropDown);
                return new List<SuppliersDropDownOutputModel>();
            }
        }

    }
}
