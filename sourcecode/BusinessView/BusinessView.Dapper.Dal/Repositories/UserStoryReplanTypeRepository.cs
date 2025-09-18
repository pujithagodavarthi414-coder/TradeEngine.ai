using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryReplanTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryReplanType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryReplanTypeDbEntity aUserStoryReplanType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReplanType.Id);
					 vParams.Add("@ReplanTypeName",aUserStoryReplanType.ReplanTypeName);
					 vParams.Add("@CreatedDateTime",aUserStoryReplanType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReplanType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryReplanType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryReplanType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryReplanTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryReplanType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryReplanTypeDbEntity aUserStoryReplanType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryReplanType.Id);
					 vParams.Add("@ReplanTypeName",aUserStoryReplanType.ReplanTypeName);
					 vParams.Add("@CreatedDateTime",aUserStoryReplanType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryReplanType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStoryReplanType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStoryReplanType.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_UserStoryReplanTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryReplanType table.
		/// </summary>
		public UserStoryReplanTypeDbEntity GetUserStoryReplanType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryReplanTypeDbEntity>("USP_UserStoryReplanTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryReplanType table.
		/// </summary>
		 public IEnumerable<UserStoryReplanTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryReplanTypeDbEntity>("USP_UserStoryReplanTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
