using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserUnPaidLeaveRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserUnPaidLeaves table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserUnPaidLeaveDbEntity aUserUnPaidLeave)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserUnPaidLeave.Id);
					 vParams.Add("@UserId",aUserUnPaidLeave.UserId);
					 vParams.Add("@UnPaidLeaves",aUserUnPaidLeave.UnPaidLeaves);
					 vParams.Add("@CreatedDateTime",aUserUnPaidLeave.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserUnPaidLeave.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserUnPaidLeave.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserUnPaidLeave.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserUnPaidLeavesInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserUnPaidLeaves table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserUnPaidLeaveDbEntity aUserUnPaidLeave)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserUnPaidLeave.Id);
					 vParams.Add("@UserId",aUserUnPaidLeave.UserId);
					 vParams.Add("@UnPaidLeaves",aUserUnPaidLeave.UnPaidLeaves);
					 vParams.Add("@CreatedDateTime",aUserUnPaidLeave.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserUnPaidLeave.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserUnPaidLeave.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserUnPaidLeave.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserUnPaidLeavesUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserUnPaidLeaves table.
		/// </summary>
		public UserUnPaidLeaveDbEntity GetUserUnPaidLeave(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserUnPaidLeaveDbEntity>("USP_UserUnPaidLeavesSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserUnPaidLeaves table.
		/// </summary>
		 public IEnumerable<UserUnPaidLeaveDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserUnPaidLeaveDbEntity>("USP_UserUnPaidLeavesSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserUnPaidLeaves table by a foreign key.
		/// </summary>
		public List<UserUnPaidLeaveDbEntity> SelectAllByUserId(Guid? userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<UserUnPaidLeaveDbEntity>("USP_UserUnPaidLeavesSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
