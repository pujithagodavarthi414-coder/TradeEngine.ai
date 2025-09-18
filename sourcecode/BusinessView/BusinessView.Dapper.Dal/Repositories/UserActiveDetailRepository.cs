using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserActiveDetailRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserActiveDetails table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserActiveDetailDbEntity aUserActiveDetail)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserActiveDetail.Id);
					 vParams.Add("@UserId",aUserActiveDetail.UserId);
					 vParams.Add("@ActiveFrom",aUserActiveDetail.ActiveFrom);
					 vParams.Add("@ActiveTo",aUserActiveDetail.ActiveTo);
					 vParams.Add("@CreatedDateTime",aUserActiveDetail.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserActiveDetail.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserActiveDetail.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserActiveDetail.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserActiveDetailsInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserActiveDetails table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserActiveDetailDbEntity aUserActiveDetail)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserActiveDetail.Id);
					 vParams.Add("@UserId",aUserActiveDetail.UserId);
					 vParams.Add("@ActiveFrom",aUserActiveDetail.ActiveFrom);
					 vParams.Add("@ActiveTo",aUserActiveDetail.ActiveTo);
					 vParams.Add("@CreatedDateTime",aUserActiveDetail.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserActiveDetail.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserActiveDetail.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserActiveDetail.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserActiveDetailsUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserActiveDetails table.
		/// </summary>
		public UserActiveDetailDbEntity GetUserActiveDetail(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserActiveDetailDbEntity>("USP_UserActiveDetailsSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserActiveDetails table.
		/// </summary>
		 public IEnumerable<UserActiveDetailDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserActiveDetailDbEntity>("USP_UserActiveDetailsSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
