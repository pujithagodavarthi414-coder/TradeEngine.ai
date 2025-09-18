using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserAuthTokenRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserAuthToken table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserAuthTokenDbEntity aUserAuthToken)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserAuthToken.Id);
					 vParams.Add("@UserId",aUserAuthToken.UserId);
					 vParams.Add("@UserName",aUserAuthToken.UserName);
					 vParams.Add("@DateCreated",aUserAuthToken.DateCreated);
					 vParams.Add("@AuthToken",aUserAuthToken.AuthToken);
					 vParams.Add("@CompanyId",aUserAuthToken.CompanyId);
					 int iResult = vConn.Execute("USP_UserAuthTokenInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserAuthToken table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserAuthTokenDbEntity aUserAuthToken)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserAuthToken.Id);
					 vParams.Add("@UserId",aUserAuthToken.UserId);
					 vParams.Add("@UserName",aUserAuthToken.UserName);
					 vParams.Add("@DateCreated",aUserAuthToken.DateCreated);
					 vParams.Add("@AuthToken",aUserAuthToken.AuthToken);
					 vParams.Add("@CompanyId",aUserAuthToken.CompanyId);
					 int iResult = vConn.Execute("USP_UserAuthTokenUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserAuthToken table.
		/// </summary>
		public UserAuthTokenDbEntity GetUserAuthToken(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserAuthTokenDbEntity>("USP_UserAuthTokenSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserAuthToken table.
		/// </summary>
		 public IEnumerable<UserAuthTokenDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserAuthTokenDbEntity>("USP_UserAuthTokenSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserAuthToken table by a foreign key.
		/// </summary>
		public List<UserAuthTokenDbEntity> SelectAllByUserId(Guid userId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@UserId",userId);
				 return vConn.Query<UserAuthTokenDbEntity>("USP_UserAuthTokenSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
