using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Dapper.Dal.Models;
using Btrak.Models;
using Btrak.Models.TimeSheet;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TimeSheetUploadRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TimeSheetUpload table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TimeSheetUploadDbEntity aTimeSheetUpload)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTimeSheetUpload.Id);
					 vParams.Add("@Date",aTimeSheetUpload.Date);
					 vParams.Add("@BranchId",aTimeSheetUpload.BranchId);
					 vParams.Add("@FileName",aTimeSheetUpload.FileName);
					 vParams.Add("@FilePath",aTimeSheetUpload.FilePath);
					 vParams.Add("@CreatedDateTime",aTimeSheetUpload.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTimeSheetUpload.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTimeSheetUpload.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTimeSheetUpload.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TimeSheetUploadInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TimeSheetUpload table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TimeSheetUploadDbEntity aTimeSheetUpload)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTimeSheetUpload.Id);
					 vParams.Add("@Date",aTimeSheetUpload.Date);
					 vParams.Add("@BranchId",aTimeSheetUpload.BranchId);
					 vParams.Add("@FileName",aTimeSheetUpload.FileName);
					 vParams.Add("@FilePath",aTimeSheetUpload.FilePath);
					 vParams.Add("@CreatedDateTime",aTimeSheetUpload.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTimeSheetUpload.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTimeSheetUpload.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTimeSheetUpload.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TimeSheetUploadUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TimeSheetUpload table.
		/// </summary>
		public TimeSheetUploadDbEntity GetTimeSheetUpload(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TimeSheetUploadDbEntity>("USP_TimeSheetUploadSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TimeSheetUpload table.
		/// </summary>
		 public IEnumerable<TimeSheetUploadDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TimeSheetUploadDbEntity>("USP_TimeSheetUploadSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the TimeSheetUpload table by a foreign key.
		/// </summary>
		public List<TimeSheetUploadDbEntity> SelectAllByBranchId(Guid branchId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@BranchId",branchId);
				 return vConn.Query<TimeSheetUploadDbEntity>("USP_TimeSheetUploadSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the TimeSheetUpload table by a foreign key.
		/// </summary>
		public List<TimeSheetUploadDbEntity> SelectAllByCreatedByUserId(Guid createdByUserId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CreatedByUserId",createdByUserId);
				 return vConn.Query<TimeSheetUploadDbEntity>("USP_TimeSheetUploadSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

        public List<PermissionRegisterReturnOutputModel> SearchPermissionRegister(PermissionRegisterSearchInputModel permissionRegisterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", permissionRegisterSearchInputModel.EmployeeId);
                    vParams.Add("@DateFrom", permissionRegisterSearchInputModel.DateFrom?.Date);
                    vParams.Add("@DateTo", permissionRegisterSearchInputModel.DateTo?.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", permissionRegisterSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", permissionRegisterSearchInputModel.PageSize);
                    vParams.Add("@SearchText", permissionRegisterSearchInputModel.SearchText);
                    vParams.Add("@SortBy", permissionRegisterSearchInputModel.SortBy);
                    vParams.Add("@EntityId", permissionRegisterSearchInputModel.EntityId);
                    vParams.Add("@SortDirection", permissionRegisterSearchInputModel.SortDirection);
                    return vConn.Query<PermissionRegisterReturnOutputModel>(StoredProcedureConstants.SpGetPermissionRegister, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchPermissionRegister", "TimeSheetUploadRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.SearchPermissionRegister);
                return new List<PermissionRegisterReturnOutputModel>();
            }
        }
        
    }
}
