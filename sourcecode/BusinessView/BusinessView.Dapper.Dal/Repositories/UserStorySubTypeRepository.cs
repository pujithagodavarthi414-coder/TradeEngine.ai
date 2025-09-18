using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStorySubTypeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStorySubType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStorySubTypeDbEntity aUserStorySubType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStorySubType.Id);
					 vParams.Add("@CompanyId",aUserStorySubType.CompanyId);
					 vParams.Add("@UserStorySubTypeName",aUserStorySubType.UserStorySubTypeName);
					 vParams.Add("@CreatedDateTime",aUserStorySubType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStorySubType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStorySubType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStorySubType.UpdatedByUserId);
					 vParams.Add("@VersionNumber",aUserStorySubType.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStorySubType.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStorySubType.OriginalId);
					 vParams.Add("@TimeStamp",aUserStorySubType.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStorySubTypeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStorySubType table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStorySubTypeDbEntity aUserStorySubType)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStorySubType.Id);
					 vParams.Add("@CompanyId",aUserStorySubType.CompanyId);
					 vParams.Add("@UserStorySubTypeName",aUserStorySubType.UserStorySubTypeName);
					 vParams.Add("@CreatedDateTime",aUserStorySubType.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStorySubType.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aUserStorySubType.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aUserStorySubType.UpdatedByUserId);
					 vParams.Add("@VersionNumber",aUserStorySubType.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStorySubType.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStorySubType.OriginalId);
					 vParams.Add("@TimeStamp",aUserStorySubType.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStorySubTypeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStorySubType table.
		/// </summary>
		public UserStorySubTypeDbEntity GetUserStorySubType(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStorySubTypeDbEntity>("USP_UserStorySubTypeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStorySubType table.
		/// </summary>
		 public IEnumerable<UserStorySubTypeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStorySubTypeDbEntity>("USP_UserStorySubTypeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStorySubType table by a foreign key.
		/// </summary>
		public List<UserStorySubTypeDbEntity> SelectAllByCompanyId(Guid companyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CompanyId",companyId);
				 return vConn.Query<UserStorySubTypeDbEntity>("USP_UserStorySubTypeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStorySubType table by a foreign key.
		/// </summary>
		public List<UserStorySubTypeDbEntity> SelectAllByOriginalId(Guid? originalId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@OriginalId",originalId);
				 return vConn.Query<UserStorySubTypeDbEntity>("USP_UserStorySubTypeSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
