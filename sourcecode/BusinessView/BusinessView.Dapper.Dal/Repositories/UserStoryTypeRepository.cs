using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryTypeDbEntity aUserStoryType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryType.Id);
					 vParams.Add("@UserStoryTypeName",aUserStoryType.UserStoryTypeName);
					 vParams.Add("@CreatedDateTime",aUserStoryType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryTypeDbEntity aUserStoryType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryType.Id);
					 vParams.Add("@UserStoryTypeName",aUserStoryType.UserStoryTypeName);
					 vParams.Add("@CreatedDateTime",aUserStoryType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryType table.
		/// </summary>
		public UserStoryTypeDbEntity GetUserStoryType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryTypeDbEntity>("USP_UserStoryTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryType table.
		/// </summary>
		 public IEnumerable<UserStoryTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryTypeDbEntity>("USP_UserStoryTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
