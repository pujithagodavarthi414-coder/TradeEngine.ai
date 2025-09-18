using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class ResetPasswordRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the ResetPassword table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(ResetPasswordDbEntity aResetPassword)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aResetPassword.Id);
					 vParams.Add("@UserId",aResetPassword.UserId);
					 vParams.Add("@ResetGuid",aResetPassword.ResetGuid);
					 vParams.Add("@IsExpired",aResetPassword.IsExpired);
					 vParams.Add("@CreatedDateTime",aResetPassword.CreatedDateTime);
					 vParams.Add("@ExpiredDateTime",aResetPassword.ExpiredDateTime);
					 int iResult = vConn.Execute("USP_ResetPasswordInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the ResetPassword table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(ResetPasswordDbEntity aResetPassword)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aResetPassword.Id);
					 vParams.Add("@UserId",aResetPassword.UserId);
					 vParams.Add("@ResetGuid",aResetPassword.ResetGuid);
					 vParams.Add("@IsExpired",aResetPassword.IsExpired);
					 vParams.Add("@CreatedDateTime",aResetPassword.CreatedDateTime);
					 vParams.Add("@ExpiredDateTime",aResetPassword.ExpiredDateTime);
					 int iResult = vConn.Execute("USP_ResetPasswordUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of ResetPassword table.
		/// </summary>
		public ResetPasswordDbEntity GetResetPassword(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<ResetPasswordDbEntity>("USP_ResetPasswordSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the ResetPassword table.
		/// </summary>
		 public IEnumerable<ResetPasswordDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<ResetPasswordDbEntity>("USP_ResetPasswordSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the ResetPassword table by a foreign key.
		/// </summary>
		public List<ResetPasswordDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<ResetPasswordDbEntity>("USP_ResetPasswordSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
