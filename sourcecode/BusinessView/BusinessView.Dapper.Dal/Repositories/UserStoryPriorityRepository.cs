using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class UserStoryPriorityRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the UserStoryPriority table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(UserStoryPriorityDbEntity aUserStoryPriority)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryPriority.Id);
					 vParams.Add("@PriorityName",aUserStoryPriority.PriorityName);
					 vParams.Add("@CompanyId",aUserStoryPriority.CompanyId);
					 vParams.Add("@CreatedDateTime",aUserStoryPriority.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryPriority.CreatedByUserId);
					 vParams.Add("@Order",aUserStoryPriority.Order);
					 vParams.Add("@IsHigh",aUserStoryPriority.IsHigh);
					 vParams.Add("@IsMedium",aUserStoryPriority.IsMedium);
					 vParams.Add("@IsLow",aUserStoryPriority.IsLow);
					 vParams.Add("@VersionNumber",aUserStoryPriority.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStoryPriority.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStoryPriority.OriginalId);
					 vParams.Add("@TimeStamp",aUserStoryPriority.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStoryPriorityInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the UserStoryPriority table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(UserStoryPriorityDbEntity aUserStoryPriority)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aUserStoryPriority.Id);
					 vParams.Add("@PriorityName",aUserStoryPriority.PriorityName);
					 vParams.Add("@CompanyId",aUserStoryPriority.CompanyId);
					 vParams.Add("@CreatedDateTime",aUserStoryPriority.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aUserStoryPriority.CreatedByUserId);
					 vParams.Add("@Order",aUserStoryPriority.Order);
					 vParams.Add("@IsHigh",aUserStoryPriority.IsHigh);
					 vParams.Add("@IsMedium",aUserStoryPriority.IsMedium);
					 vParams.Add("@IsLow",aUserStoryPriority.IsLow);
					 vParams.Add("@VersionNumber",aUserStoryPriority.VersionNumber);
					 vParams.Add("@InActiveDateTime",aUserStoryPriority.InActiveDateTime);
					 vParams.Add("@OriginalId",aUserStoryPriority.OriginalId);
					 vParams.Add("@TimeStamp",aUserStoryPriority.TimeStamp);
					 int iResult = vConn.Execute("USP_UserStoryPriorityUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of UserStoryPriority table.
		/// </summary>
		public UserStoryPriorityDbEntity GetUserStoryPriority(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<UserStoryPriorityDbEntity>("USP_UserStoryPrioritySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the UserStoryPriority table.
		/// </summary>
		 public IEnumerable<UserStoryPriorityDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<UserStoryPriorityDbEntity>("USP_UserStoryPrioritySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the UserStoryPriority table by a foreign key.
		/// </summary>
		public List<UserStoryPriorityDbEntity> SelectAllByCompanyId(Guid? companyId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@CompanyId",companyId);
				 return vConn.Query<UserStoryPriorityDbEntity>("USP_UserStoryPrioritySelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
